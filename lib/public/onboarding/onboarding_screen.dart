// onboarding_screen.dart
import 'package:eaqoonsi/language/language_widget_design.dart';
import 'package:eaqoonsi/widget/app_export.dart';

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CheckNationalIDNumber(),
          ),
        );
      } catch (e) {
        print('An error occurred: $e');
      }
    }

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (int page) {
          ref.read(currentPageProvider.notifier).state = page;
        },
        children: <Widget>[
          ChooseLanguage(pageController: pageController),

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

          // // Third page
          // makePage(
          //   context: context,
          //   image: third,
          //   title: localizations.welcomeSpalshTitle,
          //   content: localizations.welcomeSpalshSubtitle,
          // ),
        ],
      ),
      bottomSheet: currentPage != 2
          ? otherPagesBottomSheet(context, pageController, ref)
          : lastPageBottomSheet(() => completeOnboarding(context, ref)),
    );
  }

  Widget otherPagesBottomSheet(
      BuildContext context, PageController pageController, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            onPressed: () {
              pageController.animateToPage(3,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
            child: Text(localizations.skipButton,
                style: const TextStyle(color: Colors.blue)),
          ),
          Row(
            children: List.generate(3, (index) => dots(index, context, ref)),
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

  Widget lastPageBottomSheet(Future<void> Function() completeOnboarding) {
    return TextButton(
      onPressed: () async {
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

  Widget dots(int index, BuildContext context, WidgetRef ref) {
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
    required BuildContext context,
    required String title,
    required String content,
    required String image,
  }) {
    return Container(
      key: ValueKey(AppLocalizations.of(context)),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Image.asset(image, fit: BoxFit.cover),
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
