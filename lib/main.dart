import 'package:eaqoonsi/widget/app_export.dart';

void main() {
  runApp(const ProviderScope(child: MaterialApp(home: MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
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
        GlobalMaterialLocalizations.delegate,
      ],
      routes: {
        '/profile': (context) => const ProfileScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/verification': (context) => const VerificationScreen(),
        '/helpScreen': (context) => const HelpScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: "eAqoonsi",
      locale: currentLocale,

      supportedLocales: AppLocalizations.supportedLocales,

      // home: Verify(),

      home: authState.isAuthenticated
          ? const ProfileScreen()
          : const SplashScreen(),
    );
  }
}
