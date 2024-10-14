import 'package:eaqoonsi/widget/app_export.dart';

final dioProvider = Provider<DioClient>((ref) => DioClient(ref));

class DioClient {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Ref _ref;

  DioClient(this._ref) {
    _dio = Dio(BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': '898989',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['X-API-Key'] = '898989';
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          await _storage.delete(key: 'access_token');
          _ref.read(authStateProvider.notifier).logout();
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
      throw handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Exception handleError(DioException error) {
    if (error.type == DioExceptionType.connectionError) {
      final underlyingError = error.error;
      if (underlyingError is SocketException) {
        final errorMessage = underlyingError.message.toLowerCase();
        if (errorMessage.contains('failed host lookup') ||
            errorMessage.contains('temporary failure in name resolution') ||
            errorMessage.contains('unknown host')) {
          return DomainException(
              'Unable to resolve host. The domain may be down.');
        } else if (errorMessage.contains('network is unreachable') ||
            errorMessage.contains('no internet') ||
            errorMessage.contains('connection timed out')) {
          // No internet connection
          return NetworkException('No internet connection.');
        } else {
          return NetworkException(underlyingError.message);
        }
      } else {
        return NetworkException('Connection error: ${error.message}');
      }
    }

    final statusCode = error.response?.statusCode;
    final message = error.response?.data['message'] ?? 'An error occurred';

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
      throw handleError(e);
    }
  }

  Future<bool> hasInternetConnection() async {
    final connectivityResult =
        await _ref.read(connectivityProvider).checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  }
}
