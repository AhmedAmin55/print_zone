import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:meta/meta.dart';
import 'package:pdfx/pdfx.dart';

import '../../data/models/file_model.dart';

part 'drop_files_state.dart';



class DropFilesCubit extends Cubit<DropFilesState> {
  DropFilesCubit() : super(DropFilesInitial());

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

    if (state is DropFilesLoaded) {
      final s = state as DropFilesLoaded;
      emit(DropFilesLoaded(files: s.files, selectedFile: selectedFile));
    }
  }

  // =====================================================
  // 🔥 إجمالي الصفحات
  // =====================================================
  int getTotalPages() {
    if (state is! DropFilesLoaded) return 0;

    return (state as DropFilesLoaded).files.fold(
      0,
          (sum, f) => sum + (f.pageCount ?? 0),
    );
  }

  // =====================================================
  // 🔥 السعر النهائي = عدد الصفحات × سعر الورقة
  // =====================================================
  double getFinalPrice() {
    return getTotalPages() * pricePerPage;
  }

  // سعر ملف واحد
  double getFilePrice(PickedFileModel file) {
    return (file.pageCount ?? 0) * pricePerPage;
  }

  // =====================================================
  // 🔥 اختيار ملف
  // =====================================================
  void selectFile(PickedFileModel file) {
    selectedFile = file;

    if (state is DropFilesLoaded) {
      final s = state as DropFilesLoaded;
      emit(DropFilesLoaded(files: s.files, selectedFile: selectedFile));
    }
  }

  // =====================================================
  // 🔥 إضافة ملفات
  // =====================================================
  Future<void> pickAndLoadFiles() async {
    List<PickedFileModel> oldFiles = [];

    if (state is DropFilesLoaded) {
      oldFiles = List.from((state as DropFilesLoaded).files);
    }

    emit(DropFilesLoading());

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null) {
        emit(DropFilesLoaded(files: oldFiles, selectedFile: selectedFile));
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

      emit(DropFilesLoaded(files: oldFiles, selectedFile: selectedFile));
    } catch (e) {
      emit(DropFilesError(message: e.toString()));
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
    if (state is! DropFilesLoaded) return;

    final current = state as DropFilesLoaded;
    final files = List<PickedFileModel>.from(current.files);

    final index = files.indexWhere((f) => f.path == file.path);
    if (index == -1) return;

    final updated = files[index].copyWith(
      printMode: printMode,
      colorMode: colorMode,
      paperSize: paperSize,
      orientation: orientation,
    );

    files[index] = updated;

    if (selectedFile != null && selectedFile!.path == updated.path) {
      selectedFile = updated;
    }

    emit(DropFilesLoaded(files: files, selectedFile: selectedFile));
  }

  // =====================================================
  // 🔥 حذف ملف
  // =====================================================
  void removeFile(PickedFileModel file) {
    if (state is! DropFilesLoaded) return;

    final current = state as DropFilesLoaded;
    final files = List<PickedFileModel>.from(current.files);

    files.removeWhere((f) => f.path == file.path);

    if (selectedFile != null && selectedFile!.path == file.path) {
      selectedFile = files.isNotEmpty ? files.first : null;
    }

    emit(DropFilesLoaded(files: files, selectedFile: selectedFile));
  }
}
