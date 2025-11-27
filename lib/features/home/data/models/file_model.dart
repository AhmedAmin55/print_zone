import 'dart:typed_data';

class PickedFileModel {
  final String name;
  final String path;
  final Uint8List? bytes;
  final String extension;
  final int? pageCount;
  final Uint8List? thumbnail;

  final PrintMode printMode;   // وش واحد - دبلكس - 2/4
  final ColorMode colorMode;   // ملون / أبيض وأسود
  final PaperSize paperSize;   // A4 / A3 / Letter
  final OrientationMode orientation; // طولي / عرضي

  PickedFileModel({
    required this.name,
    required this.path,
    required this.bytes,
    required this.extension,
    required this.pageCount,
    required this.thumbnail,
    this.printMode = PrintMode.oneSide,
    this.colorMode = ColorMode.blackWhite,
    this.paperSize = PaperSize.a4,
    this.orientation = OrientationMode.portrait,
  });

  PickedFileModel copyWith({
    PrintMode? printMode,
    ColorMode? colorMode,
    PaperSize? paperSize,
    OrientationMode? orientation,
  }) {
    return PickedFileModel(
      name: name,
      path: path,
      bytes: bytes,
      extension: extension,
      pageCount: pageCount,
      thumbnail: thumbnail,
      printMode: printMode ?? this.printMode,
      colorMode: colorMode ?? this.colorMode,
      paperSize: paperSize ?? this.paperSize,
      orientation: orientation ?? this.orientation,
    );
  }
}

enum PrintMode {
  oneSide,       // وش واحد
  duplex,        // وش وضهر
  twoFrontBack,  // وشين وضهرين
  fourFrontBack, // 4 وشوش و4 ظهر
}

enum ColorMode {
  blackWhite,
  colored,
}

enum PaperSize {
  a4,
  a3,
  letter,
}

enum OrientationMode {
  portrait,   // طولي
  landscape,  // عرضي
}