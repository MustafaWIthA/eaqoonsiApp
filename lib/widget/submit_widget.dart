import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class SubmitButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color textColor;
  final bool isEnabled;

  const SubmitButtonWidget({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.width = 230,
    this.height = 52,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackgroundColor = isEnabled
        ? backgroundColor ?? EAqoonsiTheme.of(context).primaryBackground
        : Colors.grey; // Change to grey when disabled

    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
        child: EaqoonsiButtonWidget(
          onPressed: isEnabled ? onPressed : null, // Disable button press
          text: buttonText,
          options: EaqoonsiButtonOptions(
            width: width,
            height: height,
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            color: effectiveBackgroundColor, // Set background color
            textStyle: EAqoonsiTheme.of(context).titleSmall.override(
                  fontFamily: 'Plus Jakarta Sans',
                  color: textColor,
                  fontSize: 16,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
            elevation: 3,
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          showLoadingIndicator: true,
        ),
      ),
    );
  }
}
