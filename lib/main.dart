import 'package:eaqoonsi/widget/app_export.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: "eAqoonsi",
        debugShowCheckedModeBanner: false,
        locale: const Locale('so', 'SO'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizationsDelegate(), // Your custom delegate
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
      ),
    ),
  );
}
