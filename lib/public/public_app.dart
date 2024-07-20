import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:eaqoonsi/language/language_notifier.dart';
import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class SharedAppShell extends ConsumerWidget {
  final Widget child;
  const SharedAppShell({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageNotifier);

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: currentLocale,
      debugShowCheckedModeBanner: false,
      title: "eAqoonsi",
      theme: ThemeData(
        primaryColor: EAqoonsiTheme.of(context).primary,
        scaffoldBackgroundColor: EAqoonsiTheme.of(context).primaryBackground,
      ),
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: child,
          );
        },
      ),
    );
  }
}
