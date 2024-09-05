import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class SubmitButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color textColor;

  const SubmitButtonWidget({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.width = 230,
    this.height = 52,
    this.backgroundColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
        child: EaqoonsiButtonWidget(
          onPressed: onPressed,
          text: buttonText,
          options: EaqoonsiButtonOptions(
            width: width,
            height: height,
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            color:
                backgroundColor ?? EAqoonsiTheme.of(context).primaryBackground,
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
            borderRadius: BorderRadius.circular(40),
          ),
          showLoadingIndicator: true,
        ),
      ),
    );
  }
}
