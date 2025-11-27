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

  PickedFileModel? selectedFile;

  // ← اختار ملف وخلّي الـ state يحمل selectedFile
  void selectFile(PickedFileModel file) {
    selectedFile = file;
    if (state is DropFilesLoaded) {
      final current = state as DropFilesLoaded;
      emit(DropFilesLoaded(files: current.files, selectedFile: selectedFile));
    } else {
      // لو مفيش لسه ملفات محمّلة، انشئ حالة جديدة بملف واحد لو تحب
      emit(DropFilesLoaded(files: [], selectedFile: selectedFile));
    }
  }

  /// إضافة ملفات
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
            // افتراضيات لكل ملف جديد
            printMode: defaultPrintMode,
            colorMode: defaultColorMode,
            paperSize: defaultPaperSize,
            orientation: defaultOrientation,
          ),
        );
      }

      oldFiles.addAll(newFiles);

      // لو لم يكن هناك selectedFile سابقًا، نعيّن أول ملف جديد كافتراضي (اختياري)
      if (selectedFile == null && oldFiles.isNotEmpty) {
        selectedFile = oldFiles.first;
      }

      emit(DropFilesLoaded(files: oldFiles, selectedFile: selectedFile));
    } catch (e) {
      emit(DropFilesError(message: e.toString()));
    }
  }

  /// تعديل إعدادات ملف معين — مهم: نستخدم indexWhere ونحدّث selectedFile أيضاً
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

    // استخدم indexWhere بمفتاح ثابت (مثل path) بدلاً من indexOf
    final index = files.indexWhere((f) => f.path == file.path);
    if (index == -1) return;

    final updatedFile = files[index].copyWith(
      printMode: printMode,
      colorMode: colorMode,
      paperSize: paperSize,
      orientation: orientation,
    );

    files[index] = updatedFile;

    // إذا الملف اللي عدّلته هو الملف المختار — حدّث selectedFile ليعكس التغيير
    if (selectedFile != null && selectedFile!.path == file.path) {
      selectedFile = updatedFile;
    }

    emit(DropFilesLoaded(files: files, selectedFile: selectedFile));
  }

  /// حذف ملف
  void removeFile(PickedFileModel file) {
    if (state is! DropFilesLoaded) return;

    final current = state as DropFilesLoaded;
    final files = List<PickedFileModel>.from(current.files);

    files.removeWhere((f) => f.path == file.path);

    // لو حذفنا الملف المختار نصفي selectedFile أو نختار ملف آخر تلقائياً
    if (selectedFile != null && selectedFile!.path == file.path) {
      selectedFile = files.isNotEmpty ? files.first : null;
    }

    emit(DropFilesLoaded(files: files, selectedFile: selectedFile));
  }

  /// إجمالي الصفحات
  int getTotalPages() {
    if (state is! DropFilesLoaded) return 0;

    return (state as DropFilesLoaded).files.fold(
      0,
          (sum, f) => sum + (f.pageCount ?? 0),
    );
  }
}