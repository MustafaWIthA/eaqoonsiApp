import 'package:dio/dio.dart';
import 'package:eaqoonsi/login/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String keyRegsiter = 'http://10.0.2.2:9000/api/v1/auth/registration';

//regi provider
final registrationNotifierProvider =
    StateNotifierProvider<RegistrationNotifier, AuthState>((ref) {
  return RegistrationNotifier(ref.read(dioProvider), ref.read(storageProvider));
});

class RegistrationNotifier extends StateNotifier<AuthState> {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  RegistrationNotifier(this._dio, this._storage) : super(AuthState());

  //REGISTER, full name, email, pin, password
  Future<void> register(
      String fullName, String email, String password, String pin) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    const String pin = '12345';
    const String username = "iyomas";

    print('registering' + fullName + email + pin + password);
    print('password: ' + password);
    //set usernmae to email
    try {
      final response = await _dio.post(
        keyRegsiter,
        data: {
          'username': username,
          'fullName': fullName,
          'email': email,
          'pin': 12345,
          'password': password,
        },
      );
      // print(response);

      if (response.data['statusCodeValue'] == 200) {
        print(response.data['statusCodeValue']);
        final accessToken = response.data['body']['accessToken'] as String;
        final refreshToken = response.data['body']['refreshToken'] as String;

        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);

        state = state.copyWith(isAuthenticated: true, accessToken: accessToken);
      } else if (response.data['statusCodeValue'] == 400) {
        state = state.copyWith(
            isAuthenticated: false,
            errorMessage: response.data['body']['statusCode'] as String);
      } else {
        state = state.copyWith(
            isAuthenticated: false, errorMessage: 'An unknown error occurred');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          state = state.copyWith(
              errorMessage:
                  'Connection timeout. Please check your internet connection.');
        } else {
          state = state.copyWith(
              errorMessage: 'An error occurred. Please try again.');
        }
      } else {
        state = state.copyWith(errorMessage: 'An unexpected error occurred.');
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
