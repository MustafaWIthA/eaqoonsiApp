// choose_language_widget.dart
import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/submit_widget.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class ChooseLanguage extends ConsumerWidget {
  final PageController pageController;

  const ChooseLanguage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageNotifier);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildIconLogo(context),

          // Language selection buttons
          Column(
            children: [
              // Text(
              //   localizations.selectLanguage,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: EAqoonsiTheme.of(context).primaryText,
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 16),
              SubmitButtonWidget(
                onPressed: () {
                  ref
                      .read(languageNotifier.notifier)
                      .changeLocale(const Locale('en', 'GB'));
                },
                isEnabled: true,
                buttonText: "Af-Soomaali",
                backgroundColor: currentLocale.languageCode == 'en' &&
                        currentLocale.countryCode == 'GB'
                    ? EAqoonsiTheme.of(context).primary
                    : EAqoonsiTheme.of(context).accent4,
                textColor: currentLocale.languageCode == 'en' &&
                        currentLocale.countryCode == 'GB'
                    ? EAqoonsiTheme.of(context).info
                    : EAqoonsiTheme.of(context).secondaryText,
              ),
              const SizedBox(height: 8),
              SubmitButtonWidget(
                onPressed: () {
                  ref
                      .read(languageNotifier.notifier)
                      .changeLocale(const Locale('en', 'US'));
                },
                isEnabled: true,
                buttonText: "English",
                backgroundColor: currentLocale.languageCode == 'en' &&
                        currentLocale.countryCode == 'US'
                    ? EAqoonsiTheme.of(context).primary
                    : EAqoonsiTheme.of(context).accent4,
                textColor: currentLocale.languageCode == 'en' &&
                        currentLocale.countryCode == 'US'
                    ? EAqoonsiTheme.of(context).info
                    : EAqoonsiTheme.of(context).secondaryText,
              ),
            ],
          ),
          const Spacer(),
          // "Next" and "Skip" buttons at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                TextButton(
                  onPressed: () {
                    pageController.animateToPage(
                      2, // Assuming the last page index is 2
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text(
                    localizations.skipButton,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                // Next Button
                TextButton(
                  onPressed: () {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text(
                    localizations.nextButton,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
