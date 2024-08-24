import 'dart:async';
import 'dart:developer' as developer;

import 'package:eaqoonsi/widget/app_export.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const String _accessTokenKey = 'access_token';
  static const String _onboardingCompleteKey = 'onboardingComplete';

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _initializeApp();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    developer.log('Connectivity changed: $_connectionStatus');

    if (_connectionStatus.contains(ConnectivityResult.none)) {
      _showNoInternetDialog();
    } else {
      _initializeApp();
    }
  }

  Future<void> _initializeApp() async {
    try {
      developer.log('Starting app initialization');
      if (_connectionStatus.contains(ConnectivityResult.none)) {
        developer.log('No internet connection detected');
        _showNoInternetDialog();
        return;
      }

      developer
          .log('Internet connection confirmed, proceeding with initialization');
      final prefs = await SharedPreferences.getInstance();
      const storage = FlutterSecureStorage();

      await _checkOnboarding(prefs);
      await _checkAuthentication(storage);
    } catch (e) {
      developer.log('Error during app initialization: $e',
          error: e, stackTrace: StackTrace.current);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing app: $e')),
        );
      }
    }
  }

  void _showNoInternetDialog() {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: kBlueColor,
            body: AlertDialog(
              title: const Center(child: Text('No Internet Connection')),
              content: const Text(
                  'Please check your internet connection and try again.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Retry'),
                  onPressed: () {
                    developer.log('Retry button pressed');
                    Navigator.of(context).pop();
                    initConnectivity();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> _checkOnboarding(SharedPreferences prefs) async {
    final isOnboardingComplete = prefs.getBool(_onboardingCompleteKey) ?? false;
    ref.read(onboardingCompleteProvider.notifier).state = isOnboardingComplete;

    if (!isOnboardingComplete && mounted) {
      _navigateTo(const OnboardingScreen());
    }
  }

  Future<void> _checkAuthentication(FlutterSecureStorage storage) async {
    final accessToken = await storage.read(key: _accessTokenKey);
    final authState = ref.read(authStateProvider);

    if (authState.isAuthenticated ||
        (accessToken != null && _isTokenValid(accessToken))) {
      if (mounted) _navigateTo(const ProfileScreen());
    } else {
      if (mounted) _navigateTo(const LoginScreen());
    }
  }

  bool _isTokenValid(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final expirationDate =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      return expirationDate.isAfter(DateTime.now());
    } catch (e) {
      developer.log('Error decoding token: $e',
          error: e, stackTrace: StackTrace.current);
      return false;
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBlueColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kWhiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
