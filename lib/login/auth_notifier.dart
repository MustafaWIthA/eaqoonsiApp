import 'package:eaqoonsi/widget/app_export.dart';

class AuthState {
  final bool isAuthenticated;
  final String? accessToken;
  final String? errorMessage;
  final bool isLoading;

  AuthState({
    this.isAuthenticated = false,
    this.accessToken,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? accessToken,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accessToken: accessToken ?? this.accessToken,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthNotifier(this._dio, this._storage) : super(AuthState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _dio.post(
        keySigin,
        data: {
          'username': username,
          'password': password,
        },
      );
      print(response);

      if (response.data['statusCodeValue'] == 200) {
        final accessToken = response.data['body']['accessToken'] as String;
        final refreshToken = response.data['body']['refreshToken'] as String;

        saveToken(accessToken);
        saveRefreshToken(refreshToken);

        state = state.copyWith(isAuthenticated: true, accessToken: accessToken);
      } else if (response.data['statusCodeValue'] == 401) {
        state = state.copyWith(errorMessage: 'Invalid username or password.');
      } else {
        final errorMessage =
            response.data['error'] ?? 'Login failed. Please try again.';
        state = state.copyWith(errorMessage: errorMessage);
      }
    } catch (error) {
      if (error is DioException) {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          state = state.copyWith(
              errorMessage:
                  'Connection timeout. Please check your internet connection.');
        } else {
          state = state.copyWith(
              errorMessage: 'An error occurred. Please try again.');
        }
      } else {
        state = state.copyWith(errorMessage: 'An unexpected error occurred.');
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    print('Logging out...');
    print(await _storage.read(key: 'access_token'));

    //set language to default
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    // ... logout process
    print(await _storage.read(key: 'access_token'));
    print('Logout complete. Auth state: ${state.isAuthenticated}');

    state = AuthState();
  }

  Future<void> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');

    if (refreshToken != null) {
      try {
        final response = await _dio.post(
          'baseURL/auth/refresh',
          data: {
            'refresh_token': refreshToken,
          },
        );

        if (response.statusCode == 200) {
          final accessToken = response.data['body']['access_token'] as String;
          await _storage.write(key: 'access_token', value: accessToken);
          state = state.copyWith(accessToken: accessToken);
        } else {
          await logout();
          state = state.copyWith(
              errorMessage: 'Session expired. Please login again.');
        }
      } catch (error) {
        await logout();
        state = state.copyWith(
            errorMessage: 'An error occurred. Please login again.');
      }
    } else {
      await logout();
      state =
          state.copyWith(errorMessage: 'Session expired. Please login again.');
    }
  }

  //save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
    state = state.copyWith(accessToken: token);
  }

  //save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
    state = state.copyWith(accessToken: token);
  }
}
