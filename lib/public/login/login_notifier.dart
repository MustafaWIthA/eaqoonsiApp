import 'package:eaqoonsi/widget/app_export.dart';

final loginProvider =
    StateNotifierProvider<LoginNotifier, AsyncValue<void>>((ref) {
  final dioClient = ref.watch(dioProvider);
  return LoginNotifier(dioClient);
});

class LoginNotifier extends StateNotifier<AsyncValue> {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  LoginNotifier(this._dioClient) : super(const AsyncValue.data(null));

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await _dioClient.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );
      print(response.data['statusCodeValue']);

      if (response.statusCode == 200 &&
          response.data['statusCodeValue'] == 200) {
        final body = response.data['body'];

        if (body != null &&
            body['accessToken'] != null &&
            body['refreshToken'] != null) {
          final accessToken = body['accessToken'] as String;
          final refreshToken = body['refreshToken'] as String;
          await _storage.write(key: 'access_token', value: accessToken);
          await _storage.write(key: 'refresh_token', value: refreshToken);
          state = const AsyncValue.data(null);
        } else {
          throw UnauthorizedException('Invalid username or password.');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Invalid username or password.');
      } else {
        throw ApiException('Login failed. Please try again.');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
            'No internet connection. Please check your network settings.');
      } else {
        throw ApiException('An unexpected error occurred. Please try again.');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
