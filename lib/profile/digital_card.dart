import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewWidget extends StatefulWidget {
  final String base64Pdf;

  const PDFViewWidget({super.key, required this.base64Pdf});

  @override
  State<PDFViewWidget> createState() => _PDFViewWidgetState();
}

class _PDFViewWidgetState extends State<PDFViewWidget> {
  late Uint8List pdfBytes;
  String filePath = '';
  int pages = 0;
  bool isReady = false;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  @override
  void initState() {
    super.initState();
    if (widget.base64Pdf.isNotEmpty) {
      pdfBytes = base64Decode(widget.base64Pdf);
      _preparePDF();
    }
  }

  Future<void> _preparePDF() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/temp.pdf");
    await file.writeAsBytes(pdfBytes);
    setState(() {
      filePath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.base64Pdf.isEmpty) {
      return const Center(child: Text('No Digital data available'));
    }

    return filePath.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : PDFView(
            filePath: filePath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onRender: (pages) {
              setState(() {
                pages = pages!;
                isReady = true;
              });
            },
            onError: (error) {
              print("PDF error: ${error.toString()}");
            },
            onPageError: (page, error) {
              print('Page $page error: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
          );
  }
}
