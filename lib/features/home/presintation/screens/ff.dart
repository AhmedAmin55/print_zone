import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  final String? path;
  final List<int>? bytes; // ممكن يكون null

  const PdfViewerScreen({this.path, this.bytes, super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    if (widget.path != null) {
      _pdfController = PdfController(
        document: PdfDocument.openFile(widget.path!),
      );
    } else if (widget.bytes != null) {
      _pdfController = PdfController(
        document: PdfDocument.openData(Uint8List.fromList(widget.bytes!)),
      );
    } else {
      throw Exception("لا يوجد مصدر لعرض الـ PDF");
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("عرض PDF")),
      body: PdfView(controller: _pdfController),
    );
  }
}
