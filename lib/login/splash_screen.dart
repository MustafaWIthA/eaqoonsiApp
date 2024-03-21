import 'package:eaqoonsi/login/auth_notifier.dart';
import 'package:eaqoonsi/login/login_screen.dart';
import 'package:eaqoonsi/onboarding/onboarding_screen.dart';
import 'package:eaqoonsi/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final FlutterSecureStorage _storage = const FlutterSecureStorage();

    final accessToken = await _storage.read(key: 'access_token');

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (!isOnboardingComplete) {
      // Navigate to onboarding screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else if (authState.isAuthenticated || accessToken != null) {
      // Navigate to profile screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } else {
      // Navigate to login screen
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
