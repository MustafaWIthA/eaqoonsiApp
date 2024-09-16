import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final languageNotifier = StateNotifierProvider<LanguageNotifier, Locale>(
  (ref) => LanguageNotifier(),
);

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('so', '')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    final countryCode = prefs.getString('countryCode');
    if (languageCode != null) {
      state = Locale(languageCode, countryCode ?? '');
    }
  }

  void changeLocale(Locale newLocale) async {
    state = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
    await prefs.setString('countryCode', newLocale.countryCode ?? '');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.contains(locale);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.delegate.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
