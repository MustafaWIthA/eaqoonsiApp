import 'package:eaqoonsi/widget/app_export.dart';

class FullPDFViewer extends StatelessWidget {
  final String base64Pdf;
  final double? height;
  final VoidCallback? onTap;

  const FullPDFViewer({
    super.key,
    required this.base64Pdf,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: PDFViewWidget(
          base64Pdf: base64Pdf,
          loadingWidget: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class ClickablePDFPreview extends StatelessWidget {
  final String base64Pdf;
  final double height;

  const ClickablePDFPreview({
    super.key,
    required this.base64Pdf,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FullPDFViewer(
          base64Pdf: base64Pdf,
          height: height,
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => LandscapePDFViewer(
                    base64Pdf: base64Pdf,
                  ),
                ),
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
