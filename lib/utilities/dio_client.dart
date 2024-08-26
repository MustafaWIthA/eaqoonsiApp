import 'package:eaqoonsi/verification/verify/verify_model.dart';
import 'package:eaqoonsi/widget/app_export.dart';

final dioProvider = Provider<DioClient>((ref) => DioClient(ref));

class DioClient {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Ref _ref;
  bool _isRefreshing = false;

  DioClient(this._ref) {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://e-aqoonsi.nira.gov.so/api/v1',
      // baseUrl: 'https://e-aqoonsi.nira.gov.so/api/v1',
      // baseUrl: 'http://10.17.5.11:9000/api/v1',
      connectTimeout: const Duration(seconds: 10),
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
        if (!options.path.contains('/auth/login') &&
            !options.path.contains('/auth/refresh')) {
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
        if (e.response?.statusCode == 401 &&
            !_isRefreshing &&
            !e.requestOptions.path.contains('/auth/refresh')) {
          _isRefreshing = true;
          try {
            final refreshSuccess = await _refreshToken();
            _isRefreshing = false;
            if (refreshSuccess) {
              return handler.resolve(await _retry(e.requestOptions));
            }
          } catch (refreshError) {
            _isRefreshing = false;
            print('Token refresh failed: $refreshError');
          }
          _ref.read(authStateProvider.notifier).logout();
        }
        return handler.next(e);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(headers: {
          'X-API-Key': '898989',
        }),
      );

      print('Refresh response: ${response.data}');

      if (response.statusCode == 200 && response.data is Map) {
        final newAccessToken = response.data['token'] as String;
        final newRefreshToken = response.data['refreshToken'] as String;
        final expiresIn = response.data['expiresIn'] as int;

        await _storage.write(key: 'access_token', value: newAccessToken);
        await _storage.write(key: 'refresh_token', value: newRefreshToken);
        final expirationTime = DateTime.now().add(Duration(seconds: expiresIn));
        await _storage.write(
            key: 'token_expiration', value: expirationTime.toIso8601String());

        return true;
      }
    } catch (e) {
      print('Token refresh failed: $e');
      if (e is DioException) {
        print('Response data: ${e.response?.data}');
        print('Response headers: ${e.response?.headers}');
      }
    }
    return false;
  }

  //TODO: thsi is the function that will check if the token is expired or not
  Future<bool> _shouldRefreshToken() async {
    final expirationTimeString = await _storage.read(key: 'token_expiration');
    if (expirationTimeString == null) return true;

    final expirationTime = DateTime.parse(expirationTimeString);
    final currentTime = DateTime.now();
    final timeUntilExpiry = expirationTime.difference(currentTime);
    return timeUntilExpiry.inSeconds < 10;
  }

  Future<VerificationResponse> verifyUser(
      String verifiedUser, int verificationType) async {
    try {
      final response = await _dio.post(
        '/verification/verify',
        data: {
          'verifiedUser': verifiedUser,
          'verificationType': verificationType,
        },
      );
      return VerificationResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
