import 'package:eaqoonsi/providers/storage_provider.dart';
import 'package:eaqoonsi/widget/app_export.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(dioProvider), ref.read(storageProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthNotifier(this._dioClient, FlutterSecureStorage read) : super(AuthState());
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _dioClient.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data['body'];
        final accessToken = body['accessToken'] as String;
        final refreshToken = body['refreshToken'] as String;

        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);

        state = state.copyWith(isAuthenticated: true, accessToken: accessToken);
      } else {
        state = state.copyWith(errorMessage: 'Login failed. Please try again.');
      }
    } on UnauthorizedException {
      state = state.copyWith(errorMessage: 'Invalid username or password.');
    } on ApiException catch (e) {
      state = state.copyWith(
          errorMessage: e.message ?? 'An unexpected error occurred.');
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      state = AuthState();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error during logout');
    }
  }

  Future<void> checkAuthStatus() async {
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      state = state.copyWith(isAuthenticated: true, accessToken: token);
    }
  }
}

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
