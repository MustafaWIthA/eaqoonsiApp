import 'package:eaqoonsi/widget/app_export.dart';

// Enum to represent the app's initialization state
enum AppInitializationState {
  checking,
  noInternet,
  needsOnboarding,
  needsAuthentication,
  ready,
}

// Provider for the Connectivity service
final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

// Provider for SharedPreferences
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// Provider for FlutterSecureStorage
final secureStorageProvider =
    Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

// StateNotifier to manage the app's initialization state
class AppInitializationNotifier extends StateNotifier<AppInitializationState> {
  AppInitializationNotifier(this.ref) : super(AppInitializationState.checking) {
    _initialize();
  }

  final Ref ref;

  Future<void> _initialize() async {
    try {
      final connectivity = ref.read(connectivityProvider);
      final connectivityResult = await connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        state = AppInitializationState.noInternet;
        return;
      }

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
      state = AppInitializationState
          .noInternet; // Fallback to no internet state on error
    }
  }

  bool _isTokenValid(String token) {
    // Implement token validation logic here
    return true; // Placeholder
  }

  void retryInitialization() {
    state = AppInitializationState.checking;
    _initialize();
  }
}

// Provider for the AppInitializationNotifier
final appInitializationProvider =
    StateNotifierProvider<AppInitializationNotifier, AppInitializationState>(
        (ref) {
  return AppInitializationNotifier(ref);
});

// Usage in SplashScreen widget
class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
