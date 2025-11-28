import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
import 'package:pdfx/pdfx.dart';

import '../../data/models/file_model.dart';

part 'drop_files_four_front_back_state.dart';

class DropFilesCubitFourFront extends Cubit<DropFilesStateFourFront> {
  DropFilesCubitFourFront() : super(DropFilesFourFrontInitial());

  double pricePerPage = 0.75;
  PickedFileModel? selectedFile;

  double getFilePrice(PickedFileModel file) {
    final pages = file.pageCount ?? 0;
    final sheets = (pages / 8).ceil();
    return sheets * pricePerPage;
  }

  double getFinalPrice() {
    if (state is! DropFilesFourFrontLoaded) return 0;
    return (state as DropFilesFourFrontLoaded)
        .files
        .fold(0.0, (s, f) => s + getFilePrice(f));
  }
  void setPricePerPage(double price) {
    pricePerPage = price;

    if (state is DropFilesFourFrontLoaded) {
      final s = state as DropFilesFourFrontLoaded;
      emit(DropFilesFourFrontLoaded(files: s.files, selectedFile: selectedFile));
    }
  }

  int getTotalPages() {
    if (state is! DropFilesFourFrontLoaded) return 0;

    return (state as DropFilesFourFrontLoaded).files.fold(
      0,
          (sum, f) => sum + (f.pageCount ?? 0),
    );
  }
  Future<void> pickAndLoadFiles() async {
    List<PickedFileModel> oldFiles = [];

    if (state is DropFilesFourFrontLoaded) {
      oldFiles = List.from((state as DropFilesFourFrontLoaded).files);
    }

    emit(DropFilesFourFrontLoading());

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null) {
        emit(DropFilesFourFrontLoaded(files: oldFiles, selectedFile: selectedFile));
        return;
      }

      List<PickedFileModel> newFiles = [];

      for (final pf in result.files) {
        if (pf.path == null) continue;

        final doc = await PdfDocument.openFile(pf.path!);
        final page = await doc.getPage(1);

        final img = await page.render(
          width: page.width,
          height: page.height,
          format: .png,
        );

        await page.close();
        await doc.close();

        newFiles.add(
          PickedFileModel(
            name: pf.name,
            path: pf.path!,
            pageCount: doc.pagesCount,
            bytes: pf.bytes,
            extension: 'pdf',
            thumbnail: img?.bytes,
          ),
        );
      }

      oldFiles.addAll(newFiles);
      selectedFile ??= oldFiles.first;

      emit(DropFilesFourFrontLoaded(files: oldFiles, selectedFile: selectedFile));
    } catch (e) {
      emit(DropFilesFourFrontError(message: e.toString()));
    }
  }
}