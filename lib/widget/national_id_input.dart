import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class NationalIDInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onSubmitted;
  final String? Function(String?)? validator;

  const NationalIDInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 16),
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.send,
          obscureText: false,
          maxLength: 11,
          decoration: InputDecoration(
            labelText: localizations.verifyNationalIDNumberLabel,
            labelStyle: const TextStyle(
              color: Color(0xFF57636C),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            hintText: localizations.verifyNationalIDNumberHintText,
            hintStyle: const TextStyle(
              color: Color(0xFF57636C),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFF1F4F8),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF4B39EF),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFE0E3E7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFE0E3E7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: const Color(0xFFF1F4F8),
            counterText: '',
          ),
          style: EAqoonsiTheme.of(context).bodyLarge.override(
                fontFamily: 'Plus Jakarta Sans',
                color: const Color(0xFF101213),
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return localizations.invalidNationalIDNumber;
                } else if (value.length < 11) {
                  return localizations.invalidNationalIDNumber;
                }
                return null;
              },
          onFieldSubmitted: (_) => onSubmitted?.call(),
        ),
      ),
    );
  }
}
