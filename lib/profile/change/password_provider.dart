import 'package:eaqoonsi/widget/app_export.dart';

Future<void> changePassword(
  DioClient dioClient,
  String currentPassword,
  String newPassword,
  String confirmPassword,
) async {
  try {
    await dioClient.post(
      '/profile/change-password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
  } catch (e) {
    if (e is DioException) {
      throw _handleError(e);
    }
    throw Exception('An unexpected error occurred');
  }
}

Exception _handleError(DioException error) {
  final statusCode = error.response?.statusCode;
  final message =
      error.response?.data['body']?['message'] ?? 'An error occurred';

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
