import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
import 'package:pdfx/pdfx.dart';

import '../../data/models/file_model.dart';

part 'drop_files_duplex_state.dart';



class DropFilesCubitDuplex extends Cubit<DropFilesStateDuplex> {
  DropFilesCubitDuplex() : super(DropFilesDuplexInitial());

  double pricePerPage = 0.75;
  PickedFileModel? selectedFile;

  void setPricePerPage(double price) {
    pricePerPage = price;
    if (state is DropFilesDuplexLoaded) {
      emit(DropFilesDuplexLoaded(
        files: (state as DropFilesDuplexLoaded).files,
        selectedFile: selectedFile,
      ));
    }
  }

  void selectFile(PickedFileModel file) {
    selectedFile = file;

    if (state is DropFilesDuplexLoaded) {
      final s = state as DropFilesDuplexLoaded;
      emit(DropFilesDuplexLoaded(files: s.files, selectedFile: selectedFile));
    }
  }

  int getTotalPages() {
    if (state is! DropFilesDuplexLoaded) return 0;
    return (state as DropFilesDuplexLoaded)
        .files
        .fold(0, (s, f) => s + (f.pageCount ?? 0));
  }

  /// ****** أهم تعديل هنا ******
  /// Duplex sheets = ceil(pages / 2)
  // double getFilePrice(PickedFileModel file) {
  //   final pages = file.pageCount ?? 0;
  //
  //   final sheets = (pages / 2);
  //
  //   final price = sheets * pricePerPage;
  //
  //   print("---- DEBUG DUPLEX ----");
  //   print("Pages: $pages");
  //   print("Sheets: $sheets");
  //   print("Price: $price");
  //   print("----------------------");
  //
  //   return price;
  // }


  double getFinalPrice() {
    if (state is! DropFilesDuplexLoaded) return 0;

    // إجمالي كل الصفحات لكل الملفات
    final totalPages = (state as DropFilesDuplexLoaded)
        .files
        .fold(0, (sum, file) => sum + (file.pageCount ?? 0));

    // عدد الشيتات = ceil(totalPages / 2)
    final sheets = (totalPages / 2).ceil();

    // السعر النهائي
    return sheets * pricePerPage;
  }
  Future<void> pickAndLoadFiles() async {
    List<PickedFileModel> oldFiles = [];

    if (state is DropFilesDuplexLoaded) {
      oldFiles = List.from((state as DropFilesDuplexLoaded).files);
    }

    emit(DropFilesDuplexLoading());

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null) {
        emit(DropFilesDuplexLoaded(files: oldFiles, selectedFile: selectedFile));
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

        await doc.close(); // صح كده
      }

      oldFiles.addAll(newFiles);
      selectedFile ??= oldFiles.first;

      emit(DropFilesDuplexLoaded(files: oldFiles, selectedFile: selectedFile));
    } catch (e) {
      emit(DropFilesDuplexError(message: e.toString()));
    }
  }

  void removeFile(PickedFileModel file) {
    if (state is! DropFilesDuplexLoaded) return;

    final current = state as DropFilesDuplexLoaded;
    final files = List<PickedFileModel>.from(current.files)
      ..removeWhere((f) => f.path == file.path);

    if (selectedFile?.path == file.path) {
      selectedFile = files.isNotEmpty ? files.first : null;
    }

    emit(DropFilesDuplexLoaded(files: files, selectedFile: selectedFile));
  }
}
