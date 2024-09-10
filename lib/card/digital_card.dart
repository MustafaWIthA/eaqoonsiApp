import 'dart:async';
import 'package:eaqoonsi/widget/app_export.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewWidget extends StatefulWidget {
  final String base64Pdf;
  final bool swipeHorizontal;
  final Widget loadingWidget;
  final Widget errorWidget;

  const PDFViewWidget({
    super.key,
    required this.base64Pdf,
    this.swipeHorizontal = true,
    this.loadingWidget = const CircularProgressIndicator(),
    this.errorWidget = const Text('Error loading PDF'),
  });

  @override
  State<PDFViewWidget> createState() => _PDFViewWidgetState();
}

class _PDFViewWidgetState extends State<PDFViewWidget> {
  late Future<String> _pdfFuture;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _pdfFuture = _preparePDF();
  }

  Future<String> _preparePDF() async {
    if (widget.base64Pdf.isEmpty) {
      throw Exception('No PDF data available');
    }
    try {
      final pdfBytes = base64Decode(widget.base64Pdf);
      final dir = await getApplicationDocumentsDirectory();
      final file =
          File("${dir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.pdf");
      await file.writeAsBytes(pdfBytes);
      return file.path;
    } catch (e) {
      throw Exception('Failed to prepare PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _pdfFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: widget.loadingWidget);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return PDFView(
            filePath: snapshot.data!,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
            pageSnap: false,
            defaultPage: 0,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            onRender: (pages) {
              setState(() {
                this.pages = pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print("PDF error: $error");
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = 'Error on page $page: $error';
              });
              print('Page $page error: $error');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
          );
        } else {
          return Center(child: widget.errorWidget);
        }
      },
    );
  }

  @override
  void dispose() {
    _pdfFuture.then((filePath) async {
      try {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (error) {
        print('Error deleting temporary PDF file: $error');
      }
    });
    super.dispose();
  }
}

class LandscapePDFViewer extends StatelessWidget {
  final String base64Pdf;

  const LandscapePDFViewer({super.key, required this.base64Pdf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: RotatedBox(
          quarterTurns: 1,
          child: AspectRatio(
            aspectRatio: 1 /
                (MediaQuery.of(context).size.width /
                    MediaQuery.of(context).size.height),
            child: PDFViewWidget(
              base64Pdf: base64Pdf,
            ),
          ),
        ),
      ),
    );
  }
}
