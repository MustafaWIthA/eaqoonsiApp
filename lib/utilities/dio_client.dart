import 'package:eaqoonsi/widget/app_export.dart';
import 'package:flutter/foundation.dart';

final dioProvider = Provider<DioClient>((ref) => DioClient());

class DioClient {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://e-aqoonsi.nira.gov.so/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          if (await _refreshToken()) {
            return handler.resolve(await _retry(e.requestOptions));
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      final response = await _dio
          .post('/auth/refresh', data: {'refresh_token': refreshToken});
      if (response.statusCode == 200) {
        await _storage.write(
            key: 'access_token', value: response.data['accessToken']);
        await _storage.write(
            key: 'refresh_token', value: response.data['refreshToken']);
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Token refresh failed: $e');
      }
    }
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
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
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Connection timed out');
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            return BadRequestException(error.response?.data['message']);
          case 401:
            return UnauthorizedException(error.response?.data['message']);
          case 403:
            return ForbiddenException(error.response?.data['message']);
          case 404:
            return NotFoundException(error.response?.data['message']);
          case 500:
            return ServerException(error.response?.data['message']);
        }
        return ApiException(
            error.response?.data['message'] ?? 'Unknown error occurred');
      case DioExceptionType.cancel:
        return RequestCancelledException('Request was cancelled');
      case DioExceptionType.unknown:
        return ApiException('An unexpected error occurred');
      default:
        return ApiException('Something went wrong');
    }
  }
}
