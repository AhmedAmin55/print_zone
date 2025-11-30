import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
import 'package:pdfx/pdfx.dart';

import '../../data/models/file_model.dart';

part 'drop_files_two_front_back_state.dart';

class DropFilesCubitTwoFront extends Cubit<DropFilesStateTwoFront> {
  DropFilesCubitTwoFront() : super(DropFilesTwoFrontInitial());

  double pricePerPage = 0.75;
  PickedFileModel? selectedFile;

  double getFilePrice(PickedFileModel file) {
    final pages = file.pageCount ?? 0;
    final sheets = (pages / 4).ceil(); // 2 front + 2 back
    return sheets * pricePerPage;
  }

  void setPricePerPage(double price) {
    pricePerPage = price;

    if (state is DropFilesTwoFrontLoaded) {
      final s = state as DropFilesTwoFrontLoaded;
      emit(DropFilesTwoFrontLoaded(files: s.files, selectedFile: selectedFile));
    }
  }

  void removeFile(PickedFileModel file) {
    if (state is! DropFilesTwoFrontLoaded) return;

    final current = state as DropFilesTwoFrontLoaded;
    final files = List<PickedFileModel>.from(current.files);

    files.removeWhere((f) => f.path == file.path);

    if (selectedFile != null && selectedFile!.path == file.path) {
      selectedFile = files.isNotEmpty ? files.first : null;
    }

    emit(DropFilesTwoFrontLoaded(files: files, selectedFile: selectedFile));
  }

  void selectFile(PickedFileModel file) {
    selectedFile = file;

    if (state is DropFilesTwoFrontLoaded) {
      final s = state as DropFilesTwoFrontLoaded;
      emit(DropFilesTwoFrontLoaded(files: s.files, selectedFile: selectedFile));
    }
  }

  int getTotalPages() {
    if (state is! DropFilesTwoFrontLoaded) return 0;

    return (state as DropFilesTwoFrontLoaded).files.fold(
      0,
      (sum, f) => sum + (f.pageCount ?? 0),
    );
  }
  double getFinalPrice() {
    if (state is! DropFilesTwoFrontLoaded) return 0;

    // 1) اجمع كل الصفحات
    final totalPages = getTotalPages();

    // 2) احسب عدد الشيتات (8 صفحات لكل شيت)
    final totalSheets = (totalPages / 4).ceil();

    // 3) احسب السعر النهائي
    return totalSheets * pricePerPage;
  }

  Future<void> pickAndLoadFiles() async {
    List<PickedFileModel> oldFiles = [];

    if (state is DropFilesTwoFrontLoaded) {
      oldFiles = List.from((state as DropFilesTwoFrontLoaded).files);
    }

    emit(DropFilesTwoFrontLoading());

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null) {
        emit(
          DropFilesTwoFrontLoaded(files: oldFiles, selectedFile: selectedFile),
        );
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
          format: PdfPageImageFormat.png,
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

      emit(
        DropFilesTwoFrontLoaded(files: oldFiles, selectedFile: selectedFile),
      );
    } catch (e) {
      emit(DropFilesTwoFrontError(message: e.toString()));
    }
  }
}
