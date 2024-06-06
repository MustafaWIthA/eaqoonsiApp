import 'package:eaqoonsi/help/help_screen.dart';
import 'package:eaqoonsi/language/language_notifier.dart';
import 'package:eaqoonsi/login/auth_notifier.dart';
import 'package:eaqoonsi/login/splash_screen.dart';
import 'package:eaqoonsi/registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'profile/profile_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'verification/verification_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentLocale = ref.watch(languageNotifier);

    return MaterialApp(
      routes: {
        '/profile': (context) => const ProfileScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/verification': (context) => const VerificationScreen(),
        '/helpScreen': (context) => const HelpScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: "eAqoonsi",
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // home: Verify(),

      home: authState.isAuthenticated
          ? const ProfileScreen()
          : const SplashScreen(),
    );
  }
}
