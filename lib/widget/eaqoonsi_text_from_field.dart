import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:flutter/material.dart';

class EaqoonsiTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final bool obscureText;
  final String labelText;
  final String hintText;
  final int? maxLength;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const EaqoonsiTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.autofocus = false,
    this.obscureText = false,
    required this.labelText,
    this.maxLength,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(
          color: Color(0xFF57636C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFF1F4F8),
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF4B39EF),
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE0E3E7),
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE0E3E7),
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        filled: true,
        fillColor: const Color(0xFFF1F4F8),
      ),
      style: EAqoonsiTheme.of(context).bodyLarge.override(
            fontFamily: 'Plus Jakarta Sans',
            color: const Color(0xFF101213),
            fontSize: 16.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
          ),
      keyboardType: keyboardType,
    );
  }
}
