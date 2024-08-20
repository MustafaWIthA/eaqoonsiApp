import 'package:dio/io.dart';
import 'package:eaqoonsi/public/camera/fece_liveness.dart';
import 'package:eaqoonsi/widget/app_export.dart';

void main() {
  configureDio();

  runApp(
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
        '/': (context) => const FaceLivenessWidget(),
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
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('en', 'GB'), // Somali (using British English locale)
      ],
    );
  }
}

final Dio dio = Dio();

void configureDio() {
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    },
  );
}
