import 'package:eaqoonsi/widget/app_export.dart';

Future<void> resetPassword(
  DioClient dioClient,
  String nationalIDNumber,
) async {
  try {
    await dioClient.post(
      '/password/reset-password',
      data: {'nationalID': nationalIDNumber},
    );
    // If we reach here, it means the request was successful
    return;
  } on DioException catch (e) {
    // Let the DioClient handle the error
    throw _handleError(e);
  } catch (e) {
    // For any other unexpected errors
    throw Exception('An unexpected error occurred: $e');
  }
}

Exception _handleError(DioException error) {
  final statusCode = error.response?.statusCode;
  final message = error.response?.data ?? 'An error occurred';

  print('DioException caught: Status Code: $statusCode, Message: $message');

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
