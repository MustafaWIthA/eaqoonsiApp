import 'package:eaqoonsi/widget/app_export.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnboardingComplete = prefs.getBool('onboardingComplete') ?? false;
    ref.read(onboardingCompleteProvider.notifier).state = isOnboardingComplete;
    final authState = ref.watch(authStateProvider);
    const FlutterSecureStorage storage = FlutterSecureStorage();

    final accessToken = await storage.read(key: 'access_token');

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (!isOnboardingComplete) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else if (authState.isAuthenticated || accessToken != null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading ? const CircularProgressIndicator() : null,
      ),
    );
  }
}
