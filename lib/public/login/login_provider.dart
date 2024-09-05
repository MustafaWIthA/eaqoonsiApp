import 'package:eaqoonsi/public/login/login_response.dart';
import 'package:eaqoonsi/widget/app_export.dart';

final loginProvider = FutureProvider.family<LoginResponse, LoginCredentials>(
    (ref, credentials) async {
  final dioClient = ref.read(dioProvider);
  try {
    final response = await dioClient.post(
      '/auth/login',
      data: {
        'username': credentials.username,
        'password': credentials.password,
      },
    );

    final data = response.data['body'];
    final accessToken = data['accessToken'] as String;
    final refreshToken = data['refreshToken'] as String;
    // final expiresIn = data['expiresIn'] as int;

    final storage = ref.read(secureStorageProvider);
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);

    return data;
  } on DioException catch (e) {
    throw _handleDioError(e);
  }
});

Exception _handleDioError(DioException error) {
  if (error.response != null) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    switch (statusCode) {
      case 401:
        return UnauthorizedException(data['message'] ?? 'Unauthorized');
      case 400:
        return BadRequestException(data['message'] ?? 'Bad request');
      case 404:
        return NotFoundException(data['message'] ?? 'Not found');
      case 500:
        return ServerException(data['message'] ?? 'Server error');
      default:
        return ApiException(data['message'] ?? 'Unknown error occurred');
    }
  } else {
    return NetworkException('Network error occurred');
  }
}

class LoginCredentials {
  final String username;
  final String password;

  LoginCredentials({required this.username, required this.password});
}
