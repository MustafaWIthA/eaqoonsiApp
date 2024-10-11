// main.dart

import 'package:eaqoonsi/public/login/login_response.dart';
import 'package:eaqoonsi/widget/app_export.dart';

// login_page.dart
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProviders);

    return MaterialApp(
      title: 'Flutter Demo',
      home: authStateAsync.when(
        data: (authState) {
          if (authState.isAuthenticated) {
            return const ProfilePage();
          } else {
            return const LoginPage();
          }
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          body: Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

class CardResponseDTO {
  final String idNumber;
  final String fullName;
  final String somaliFullName;
  final String sex;
  final String dateOfBirth;
  final String issueDate;
  final String placeOfBirth;
  final String permanentAddress;
  final String expiryDate;
  final String nationality;
  final String photograph;
  final String profileId;
  final String mobileIDPdf;

  CardResponseDTO({
    required this.idNumber,
    required this.fullName,
    required this.somaliFullName,
    required this.sex,
    required this.dateOfBirth,
    required this.issueDate,
    required this.placeOfBirth,
    required this.permanentAddress,
    required this.expiryDate,
    required this.nationality,
    required this.photograph,
    required this.profileId,
    required this.mobileIDPdf,
  });

  factory CardResponseDTO.fromJson(Map<String, dynamic> json) {
    return CardResponseDTO(
      idNumber: json['idNumber'] as String,
      fullName: json['fullName'] as String,
      somaliFullName: json['somaliFullName'] as String,
      sex: json['sex'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      issueDate: json['issueDate'] as String,
      placeOfBirth: json['placeOfBirth'] as String,
      permanentAddress: json['permanentAddress'] as String,
      expiryDate: json['expiryDate'] as String,
      nationality: json['nationality'] as String,
      photograph: json['photograph'] as String,
      profileId: json['profileId'] as String,
      mobileIDPdf: json['mobileIDPdf'] as String,
    );
  }
}

class Profile {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String fullName;
  final String userStatus;
  final String photo;
  final CardResponseDTO cardResponseDTO;

  Profile({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.fullName,
    required this.userStatus,
    required this.photo,
    required this.cardResponseDTO,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      userStatus: json['userStatus'] as String,
      photo: json['photo'] as String,
      cardResponseDTO: CardResponseDTO.fromJson(json['cardResponseDTO']),
    );
  }
}

// auth_state.dart

class AuthState {
  final bool isAuthenticated;
  final String? accessToken;
  final String? refreshToken;

  AuthState({
    required this.isAuthenticated,
    this.accessToken,
    this.refreshToken,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

final authStateProviders =
    AsyncNotifierProvider<AuthStateNotifier, AuthState>(AuthStateNotifier.new);

class AuthStateNotifier extends AsyncNotifier<AuthState> {
  late final TokenManager _tokenManager;

  @override
  Future<AuthState> build() async {
    _tokenManager = TokenManager();

    final accessToken = await _tokenManager.getAccessToken();
    final refreshToken = await _tokenManager.getRefreshToken();

    if (accessToken != null && refreshToken != null) {
      return AuthState(
        isAuthenticated: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } else {
      return AuthState(isAuthenticated: false);
    }
  }

  Future<void> setAuthenticated(String accessToken, String refreshToken) async {
    await _tokenManager.saveTokens(accessToken, refreshToken);
    state = AsyncData(AuthState(
      isAuthenticated: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
    ));
  }

  Future<void> logout() async {
    await _tokenManager.deleteTokens();
    state = AsyncData(AuthState(isAuthenticated: false));
  }
}

// token_manager.dart

final tokenManagerProvider = Provider<TokenManager>((ref) {
  return TokenManager();
});

// api_client.dart

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref);
});

class ApiClient {
  static const String baseUrl = 'https://staging.eaqoonsi.nira.gov.so/api';
  final Dio _dio = Dio();
  final Ref _ref;
  late final TokenManager _tokenManager;

  ApiClient(this._ref) {
    _tokenManager = TokenManager();

    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final authStateAsync = _ref.read(authStateProviders);

        if (authStateAsync.hasValue) {
          final authState = authStateAsync.value!;
          if (authState.isAuthenticated && authState.accessToken != null) {
            options.headers['Authorization'] =
                'Bearer ${authState.accessToken}';
          }
        }
        options.headers['X-API-KEY'] = '898989';
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          await _ref.read(authStateProviders.notifier).logout();
        }
        return handler.next(e);
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _tokenManager.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        '/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        await _ref.read(authStateProviders.notifier).setAuthenticated(
              loginResponse.accessToken,
              loginResponse.refreshToken,
            );
        return true;
      }
    } on DioException catch (e) {
      throw handleError(e);
    }
    return false;
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Exception handleError(DioException error) {
    if (error.type == DioExceptionType.connectionError) {
      return NetworkException('No internet connection');
    }
    final statusCode = error.response?.statusCode;
    final message = error.response?.data['message'] ?? 'An error occurreds';

    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 500:
        return ServerException(message);
      default:
        return ApiException(message);
    }
  }

  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await post(
        '/v1/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );
      final loginResponse = LoginResponse.fromJson(response.data);
      await _ref.read(authStateProviders.notifier).setAuthenticated(
            loginResponse.accessToken,
            loginResponse.refreshToken,
          );
      return loginResponse;
    } on ApiException catch (error) {
      // Handle API exceptions
      throw error;
    }
  }

  Future<Profile> getProfile() async {
    try {
      final response = await get('/v1/profile');
      return Profile.fromJson(response.data);
    } on ApiException catch (error) {
      throw error;
    }
  }
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // login_page.dart

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
    } on BadRequestException {
      setState(() {
        _errorMessage = 'Invalid username or password.';
      });
    } on NetworkException {
      setState(() {
        _errorMessage = 'No internet connection. Please check your network.';
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  Profile? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _fetchProfile() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final profile = await apiClient.getProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } on NetworkException {
      setState(() {
        _errorMessage = 'No internet connection. Please check your network.';
        _isLoading = false;
      });
    } on UnauthorizedException {
      // Logout the user
      await ref.read(authStateProviders.notifier).logout();
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
        _isLoading = false;
      });
    }
  }

  void _logout() {
    ref.read(authStateProviders.notifier).logout();
    ref.read(tokenManagerProvider).deleteTokens();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProviders);

    if (authState.hasValue) {
      final authStates = authState.value!;
      if (!authStates.isAuthenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
                ? Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  )
                : _buildProfileView(),
      ),
    );
  }

  Widget _buildProfileView() {
    if (_profile == null) return const Text('No profile data');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile photo
          if (_profile!.photo.isNotEmpty)
            CircleAvatar(
              radius: 50,
              backgroundImage: MemoryImage(
                base64Decode(_profile!.photo),
              ),
            ),
          const SizedBox(height: 20),
          Text(
            'Welcome, ${_profile!.fullName}',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Email'),
            subtitle: Text(_profile!.email),
          ),
          ListTile(
            title: const Text('Username'),
            subtitle: Text(_profile!.username),
          ),
          const SizedBox(height: 20),
          const Text('Card Details', style: TextStyle(fontSize: 20)),
          ListTile(
            title: const Text('ID Number'),
            subtitle: Text(_profile!.cardResponseDTO.idNumber),
          ),
          ListTile(
            title: const Text('Full Name'),
            subtitle: Text(_profile!.cardResponseDTO.fullName),
          ),
          // Add more fields as needed
        ],
      ),
    );
  }
}
