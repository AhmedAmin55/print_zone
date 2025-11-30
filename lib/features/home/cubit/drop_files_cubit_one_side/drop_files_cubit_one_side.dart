import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:meta/meta.dart';
import 'package:pdfx/pdfx.dart';

import '../../data/models/file_model.dart';

part 'drop_files_state_one_side.dart';



class DropFilesCubitOneSide extends Cubit<DropFilesStateOneSide> {
  DropFilesCubitOneSide() : super(DropFilesOneSideInitial());

  /// الإعدادات الافتراضية
  PrintMode defaultPrintMode = PrintMode.oneSide;
  ColorMode defaultColorMode = ColorMode.blackWhite;
  PaperSize defaultPaperSize = PaperSize.a4;
  OrientationMode defaultOrientation = OrientationMode.portrait;

  /// سعر الورقة
  double pricePerPage = 0.75;

  /// الملف المختار
  PickedFileModel? selectedFile;

  // =====================================================
  // 🔥 تعيين سعر الورقة
  // =====================================================
  void setPricePerPage(double price) {
    pricePerPage = price;

    if (state is DropFilesOneSideLoaded) {
      final s = state as DropFilesOneSideLoaded;
      emit(DropFilesOneSideLoaded(files: s.files, selectedFile: selectedFile));
    }
  }

  // =====================================================
  // 🔥 إجمالي الصفحات
  // =====================================================
  int getTotalPages() {
    if (state is! DropFilesOneSideLoaded) return 0;

    return (state as DropFilesOneSideLoaded).files.fold(
      0,
          (sum, f) => sum + (f.pageCount ?? 0),
    );
  }

  // =====================================================
  // 🔥 السعر النهائي = عدد الصفحات × سعر الورقة
  // =====================================================
  double getFinalPrice() {
    if (state is! DropFilesOneSideLoaded) return 0;

    final files = (state as DropFilesOneSideLoaded).files;

    double total = 0;

    for (var f in files) {
      total += getFilePrice(f);
    }

    return total;
  }

  // سعر ملف واحد
  double getFilePrice(PickedFileModel file) {
    final pages = file.pageCount ?? 0;

    return pages * pricePerPage;

    // int sheets = pages;
    // switch (file.printMode) {
    //   case PrintMode.oneSide:
    //     sheets = pages; // كل صفحة ورقة
    //     break;
    //   case PrintMode.duplex:
    //     sheets = (pages / 2).round();  // كل ورقة عليها وجهين
    //     break;
    //   case PrintMode.twoFrontBack:
    //     sheets = (pages / 4).round();  // نفس فكرة الوشين (لو ليها حساب تاني عدّله)
    //     break;
    //   case PrintMode.fourFrontBack:
    //     sheets = (pages / 8).round();  // كل ورقة 4 وشوش (لو هي دي نيتك)
    //     break;
    // }
    // return sheets * pricePerPage;
  }
  // =====================================================
  // 🔥 اختيار ملف
  // =====================================================
  void selectFile(PickedFileModel file) {
    selectedFile = file;

    if (state is DropFilesOneSideLoaded) {
      final s = state as DropFilesOneSideLoaded;
      emit(DropFilesOneSideLoaded(files: s.files, selectedFile: selectedFile));
    }
  }

  // =====================================================
  // 🔥 إضافة ملفات
  // =====================================================
  Future<void> pickAndLoadFiles() async {
    List<PickedFileModel> oldFiles = [];

    if (state is DropFilesOneSideLoaded) {
      oldFiles = List.from((state as DropFilesOneSideLoaded).files);
    }

    emit(DropFilesOneSideLoading());

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null) {
        emit(DropFilesOneSideLoaded(files: oldFiles, selectedFile: selectedFile));
        return;
      }

      List<PickedFileModel> newFiles = [];

      for (final pf in result.files) {
        if (pf.path == null) continue;

        final doc = await PdfDocument.openFile(pf.path!);
        final pageCount = doc.pagesCount;

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
            bytes: pf.bytes,
            extension: 'pdf',
            pageCount: pageCount,
            thumbnail: img?.bytes,

            /// الإعدادات الافتراضية
            printMode: defaultPrintMode,
            colorMode: defaultColorMode,
            paperSize: defaultPaperSize,
            orientation: defaultOrientation,
          ),
        );
      }

      oldFiles.addAll(newFiles);

      if (selectedFile == null && oldFiles.isNotEmpty) {
        selectedFile = oldFiles.first;
      }

      emit(DropFilesOneSideLoaded(files: oldFiles, selectedFile: selectedFile));
    } catch (e) {
      emit(DropFilesOneSideError(message: e.toString()));
    }
  }

  // =====================================================
  // 🔥 تعديل إعدادات ملف
  // =====================================================
  void updateFileSettings(
      PickedFileModel file, {
        PrintMode? printMode,
        ColorMode? colorMode,
        PaperSize? paperSize,
        OrientationMode? orientation,
      }) {

    if (state is! DropFilesOneSideLoaded) return;

    final s = state as DropFilesOneSideLoaded;
    final files = List<PickedFileModel>.from(s.files);

    final index = files.indexWhere((f) => f.path == file.path);
    if (index == -1) return;

    final updated = files[index].copyWith(
      printMode: printMode,
      colorMode: colorMode,
      paperSize: paperSize,
      orientation: orientation,
    );

    files[index] = updated;

    // تحديث الملف المختار
    if (selectedFile != null && selectedFile!.path == updated.path) {
      selectedFile = updated;
    }

    // أهم جزء: إعادة emit لضمان إعادة حساب السعر
    emit(DropFilesOneSideLoaded(
      files: files,
      selectedFile: selectedFile,
    ));
  }

  // =====================================================
  // 🔥 حذف ملف
  // =====================================================
  void removeFile(PickedFileModel file) {
    if (state is! DropFilesOneSideLoaded) return;

    final current = state as DropFilesOneSideLoaded;
    final files = List<PickedFileModel>.from(current.files);

    files.removeWhere((f) => f.path == file.path);

    if (selectedFile != null && selectedFile!.path == file.path) {
      selectedFile = files.isNotEmpty ? files.first : null;
    }

    emit(DropFilesOneSideLoaded(files: files, selectedFile: selectedFile));
  }
}
