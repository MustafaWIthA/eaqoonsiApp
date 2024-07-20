import 'package:eaqoonsi/public/digital/check_registration.dart';
import 'package:eaqoonsi/language/language_notifier.dart';
import 'package:eaqoonsi/language/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eaqoonsi/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    final PageController pageController = PageController(initialPage: 0);
    final localizations = AppLocalizations.of(context)!;

    Future<void> completeOnboarding(BuildContext context, WidgetRef ref) async {
      final prefs = await SharedPreferences.getInstance();

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ));

      try {
        ref.read(onboardingCompleteProvider.notifier).state = true;

        await prefs.setBool('onboardingComplete', true);
        Navigator.pop(context);
        ref
            .read(languageNotifier.notifier)
            .changeLocale(const Locale('en', ''));

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CheckNationalIDNumber()));
      } catch (e) {
        print('An error occurred: $e');
      }
    }

    return MaterialApp(
      home: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (int page) {
            ref.read(currentPageProvider.notifier).state = page;
          },
          children: <Widget>[
            makePage(
              context: context,
              image: eaqoonsi,
              title: localizations.appName,
              content: localizations.appDescription,
            ),
            makePage(
              context: context,
              image: second,
              title: localizations.empoweringTitle,
              content: localizations.empoweringSubtitle,
            ),
            makePage(
              context: context,
              image: third,
              title: localizations.welcomeSpalshTitle,
              content: localizations.welcomeSpalshSubtitle,
            ),
          ],
        ),
        bottomSheet: currentPage != 2
            ? buildNonLastPageBottomSheet(context, pageController, ref)
            : buildLastPageBottomSheet(() => completeOnboarding(context, ref)),
      ),
    );
  }

  Widget buildNonLastPageBottomSheet(
      BuildContext context, PageController pageController, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(eaqoonsi),
          TextButton(
            onPressed: () {
              pageController.animateToPage(2,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
            child: Text(localizations.skipButton,
                style: const TextStyle(color: Colors.blue)),
          ),
          Row(
            children:
                List.generate(3, (index) => buildDot(index, context, ref)),
          ),
          TextButton(
            onPressed: () {
              pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
            child: Text(localizations.nextButton,
                style: const TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget buildLastPageBottomSheet(Future<void> Function() completeOnboarding) {
    return TextButton(
      onPressed: () async {
        //set onboarding complete to true
        await completeOnboarding();
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(),
        backgroundColor: Colors.blue,
        minimumSize: const Size.fromHeight(80),
      ),
      child: const Text('GET STARTED', style: TextStyle(color: Colors.white)),
    );
  }

  Widget buildDot(int index, BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    return Container(
      height: 10,
      width: currentPage == index ? 30 : 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget makePage({
    required BuildContext context, // Add this line

    required String title,
    required String content,
    required String image,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                Image.asset(image, fit: BoxFit.cover),
                if (title == 'eAqoonsi')
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.5,
                    left: MediaQuery.of(context).size.height * 0.18,
                    child: const LanguageSelectionButtons(),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    content,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
