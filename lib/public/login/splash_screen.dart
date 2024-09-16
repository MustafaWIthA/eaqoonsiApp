import 'package:eaqoonsi/widget/app_export.dart';

enum AppInitializationState {
  checking,
  noInternet,
  needsOnboarding,
  needsAuthentication,
  ready,
}

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final secureStorageProvider =
    Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

class AppInitializationNotifier extends StateNotifier<AppInitializationState> {
  AppInitializationNotifier(this.ref) : super(AppInitializationState.checking) {
    _initialize();
  }

  final Ref ref;

  Future<void> _initialize() async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final isOnboardingComplete = prefs.getBool('onboardingComplete') ?? false;

      if (!isOnboardingComplete) {
        state = AppInitializationState.needsOnboarding;
        return;
      }

      final storage = ref.read(secureStorageProvider);
      final accessToken = await storage.read(key: 'access_token');

      if (accessToken == null || !_isTokenValid(accessToken)) {
        state = AppInitializationState.needsAuthentication;
      } else {
        state = AppInitializationState.ready;
      }
    } catch (e) {
      print('Error during initialization: $e');
      state = AppInitializationState.noInternet;
    }
  }

  bool _isTokenValid(String token) {
    return true;
  }

  void retryInitialization() {
    state = AppInitializationState.checking;
    _initialize();
  }
}

final appInitializationProvider =
    StateNotifierProvider<AppInitializationNotifier, AppInitializationState>(
        (ref) {
  return AppInitializationNotifier(ref);
});

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initializationState = ref.watch(appInitializationProvider);

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: _buildContent(context, initializationState, ref),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, AppInitializationState state, WidgetRef ref) {
    switch (state) {
      case AppInitializationState.checking:
        return const CircularProgressIndicator(color: Colors.white);
      case AppInitializationState.noInternet:
        return _buildNoInternetWidget(ref);
      case AppInitializationState.needsOnboarding:
        return _buildNavigationWidget(const OnboardingScreen());
      case AppInitializationState.needsAuthentication:
        return _buildNavigationWidget(const LoginScreen());
      case AppInitializationState.ready:
        return _buildNavigationWidget(const ProfileScreen());
    }
  }

  Widget _buildNoInternetWidget(WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('No Internet Connection',
            style: TextStyle(color: Colors.white)),
        ElevatedButton(
          onPressed: () => ref
              .read(appInitializationProvider.notifier)
              .retryInitialization(),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildNavigationWidget(Widget destinationScreen) {
    return FutureBuilder(
      future: Future.microtask(() {}),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => destinationScreen),
            );
          });
        }
        return const CircularProgressIndicator(color: Colors.white);
      },
    );
  }
}
