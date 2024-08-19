import 'package:eaqoonsi/widget/app_export.dart';

final dioProvider = Provider<DioClient>((ref) => DioClient());

class DioClient {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://e-aqoonsi.nira.gov.so/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': '898989',
      },
    ));
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['X-API-Key'] = '898989';
        if (!options.path.contains('/auth/login')) {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.data is Map && response.data['statusCodeValue'] != null) {
          response.statusCode = response.data['statusCodeValue'];
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        // Handle errors based on statusCodeValue if available
        if (e.response?.data is Map &&
            e.response?.data['statusCodeValue'] != null) {
          e.response?.statusCode = e.response?.data['statusCodeValue'];
        }
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
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
}
