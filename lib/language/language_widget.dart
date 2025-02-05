import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eaqoonsi/language/language_notifier.dart';
import 'package:eaqoonsi/widget/e_aqoonsi_button_widgets.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class LanguageSelectionButtons extends ConsumerWidget {
  const LanguageSelectionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageNotifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EaqoonsiButtonWidget(
          onPressed: () {
            ref
                .read(languageNotifier.notifier)
                .changeLocale(const Locale('en', 'GB'));
          },
          text: 'SO',
          options: EaqoonsiButtonOptions(
            width: 50,
            height: 40,
            color: currentLocale.languageCode == 'en' &&
                    currentLocale.countryCode == 'GB'
                ? EAqoonsiTheme.of(context).accent1
                : Colors.transparent,
            textStyle: TextStyle(
              color: currentLocale.languageCode == 'en' &&
                      currentLocale.countryCode == 'GB'
                  ? EAqoonsiTheme.of(context).primaryText
                  : EAqoonsiTheme.of(context).secondaryText,
            ),
          ),
        ),
        const SizedBox(width: 10),
        EaqoonsiButtonWidget(
          onPressed: () {
            ref
                .read(languageNotifier.notifier)
                .changeLocale(const Locale('en', 'US'));
          },
          text: 'EN',
          options: EaqoonsiButtonOptions(
            width: 50,
            height: 40,
            color: currentLocale.languageCode == 'en' &&
                    currentLocale.countryCode == 'US'
                ? EAqoonsiTheme.of(context).primaryBackground
                : Colors.transparent,
            textStyle: TextStyle(
              color: currentLocale.languageCode == 'en' &&
                      currentLocale.countryCode == 'US'
                  ? EAqoonsiTheme.of(context).tertiary
                  : EAqoonsiTheme.of(context).secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}
