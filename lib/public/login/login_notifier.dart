import 'package:eaqoonsi/widget/app_export.dart';

final loginProvider =
    StateNotifierProvider<LoginNotifier, AsyncValue<void>>((ref) {
  final dioClient = ref.watch(dioProvider);
  return LoginNotifier(dioClient);
});

class LoginNotifier extends StateNotifier<AsyncValue<void>> {
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

      // Extract tokens directly from the response data
      final accessToken = response.data['accessToken'] as String?;
      final refreshToken = response.data['refreshToken'] as String?;

      if (accessToken != null &&
          accessToken.isNotEmpty &&
          refreshToken != null &&
          refreshToken.isNotEmpty) {
        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);
        state = const AsyncValue.data(null);
      } else {
        throw UnauthorizedException('Invalid credentials provided.');
      }
    } on UnauthorizedException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } on DioException catch (e) {
      state = AsyncValue.error(_dioClient.handleError(e), StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(
          ApiException('An unexpected error occurred.'), StackTrace.current);
    }
  }
}
