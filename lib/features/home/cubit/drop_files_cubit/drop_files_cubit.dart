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
  PrintMode defaultPrintMode = PrintMode.duplex;
  ColorMode defaultColorMode = ColorMode.colored;
  PaperSize defaultPaperSize = PaperSize.a4;
  OrientationMode defaultOrientation = OrientationMode.portrait;
  PickedFileModel? selectedFile;

  void selectFile(PickedFileModel file) {
    selectedFile = file;
    if (state is DropFilesLoaded) {
      emit(DropFilesLoaded(files: (state as DropFilesLoaded).files));
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
        emit(DropFilesLoaded(files: oldFiles));
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
      emit(DropFilesLoaded(files: oldFiles));
    } catch (e) {
      emit(DropFilesError(message: e.toString()));
    }
  }

  /// تعديل إعدادات ملف معين
  void updateFileSettings(
    PickedFileModel file, {
    PrintMode? printMode,
    ColorMode? colorMode,
    PaperSize? paperSize,
    OrientationMode? orientation,
  }) {
    if (state is! DropFilesLoaded) return;
    final files = List<PickedFileModel>.from((state as DropFilesLoaded).files);
    final index = files.indexOf(file);
    if (index == -1) return;
    files[index] = files[index].copyWith(
      printMode: printMode,
      colorMode: colorMode,
      paperSize: paperSize,
      orientation: orientation,
    );
    emit(DropFilesLoaded(files: files));
  }

  /// حذف ملف
  void removeFile(PickedFileModel file) {
    if (state is! DropFilesLoaded) return;

    final files = List<PickedFileModel>.from((state as DropFilesLoaded).files);

    files.remove(file);

    emit(DropFilesLoaded(files: files));
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
