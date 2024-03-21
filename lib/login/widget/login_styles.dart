import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LoginStyles {
  static InputDecoration textFieldDecoration(
      String hintText, String labelText, BuildContext context) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Color(0xFF57636C),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      hintText: hintText,
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
    );
  }
}
