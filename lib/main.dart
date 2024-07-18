import 'package:eaqoonsi/widget/app_export.dart';

void main() {
  runApp(
    //provider scope
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageNotifier);

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        SoMaterialLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/verification': (context) => const VerificationScreen(),
        '/helpScreen': (context) => const HelpScreen(),
        '/account': (context) => const AccountScreen(),
        '/help': (context) => const HelpScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: "eAqoonsi",
      locale: currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
