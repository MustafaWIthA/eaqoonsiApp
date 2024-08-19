import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:eaqoonsi/widget/app_export.dart';

final qrCodeDataProvider =
    StateProvider<String>((ref) => 'Default QR Code Data');

class PDFActionButtons extends ConsumerWidget {
  final VoidCallback? onBlueButtonPressed;
  final VoidCallback? onYellowButtonPressed;

  const PDFActionButtons({
    super.key,
    this.onBlueButtonPressed,
    this.onYellowButtonPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
              child: EaqoonsiButtonWidget(
                onPressed: onBlueButtonPressed,
                text: "blue", // Add this to your localizations

                options: EaqoonsiButtonOptions(
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: 52,
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: EAqoonsiTheme.of(context).primaryBackground,
                  textStyle: EAqoonsiTheme.of(context).titleSmall.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                  elevation: 3,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                showLoadingIndicator: true,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
              child: EaqoonsiButtonWidget(
                onPressed: () => _showQRCodeDialog(context, ref),
                text: "view full ID", // Add this to your localizations
                options: EaqoonsiButtonOptions(
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: 52,
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: EAqoonsiTheme.of(context).secondaryBackground,
                  textStyle: EAqoonsiTheme.of(context).titleSmall.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: EAqoonsiTheme.of(context).primaryText,
                        fontSize: 16,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                  elevation: 3,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                showLoadingIndicator: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQRCodeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scan QR Code'),
          content: const Text("hio"),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
