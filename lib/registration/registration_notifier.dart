import 'package:eaqoonsi/providers/storage_provider.dart';
import 'package:eaqoonsi/registration/dio_providers.dart';
import 'package:eaqoonsi/widget/app_export.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

const String keyRegsiter =
    'https://e-aqoonsi.nira.gov.so/api/v1/auth/registration';

final registrationNotifierProvider =
    StateNotifierProvider<RegistrationNotifier, AuthState>((ref) {
  return RegistrationNotifier(ref.read(dioProviders as ProviderListenable<Dio>),
      ref.read(storageProvider));
});

class RegistrationNotifier extends StateNotifier<AuthState> {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  File? _capturedImage;
  String? _userName;

  RegistrationNotifier(this._dio, this._storage) : super(AuthState());

  void setCapturedImage(File image) {
    _capturedImage = image;
  }

  void setUserName(String userName) {
    _userName = userName;
  }

  Future<void> register(
      String fullName, String email, String password, String pin) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    if (_capturedImage == null) {
      state =
          state.copyWith(isLoading: false, errorMessage: 'No image selected');
      return;
    }

    if (_userName == null) {
      state = state.copyWith(isLoading: false, errorMessage: 'No username');
      return;
    }

    try {
      final compressedImage = await compressFile(_capturedImage!);
      if (compressedImage == null) {
        state = state.copyWith(
            isLoading: false, errorMessage: 'Failed to compress image');
        return;
      }

      final tempDir = await getTemporaryDirectory();
      print('tempDir: $tempDir');
      final tempImagePath = '${tempDir.path}/compressed_image.jpg';
      final tempImageFile = File(tempImagePath);
      await tempImageFile.writeAsBytes(compressedImage);

      final formData = FormData.fromMap({
        'username': _userName,
        'photo': await MultipartFile.fromFile(tempImageFile.path,
            filename: 'image.jpg'),
        'fullName': fullName,
        'email': email,
        'password': password,
      });

      final response = await _dio.post(
        keyRegsiter,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-API-Key': 898989,
          },
        ),
        data: formData,
      );

      if (response.data['statusCodeValue'] == 200) {
        final accessToken = response.data['body']['accessToken'] as String;
        final refreshToken = response.data['body']['refreshToken'] as String;
        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);
        state = state.copyWith(isAuthenticated: true, accessToken: accessToken);
      } else if (response.data['statusCodeValue'] == 400) {
        state = state.copyWith(
          isAuthenticated: false,
          errorMessage: response.data['body']['statusCode'] as String,
        );
      } else if (response.data['statusCodeValue'] == 409) {
        state = state.copyWith(
          isAuthenticated: false,
          errorMessage: "User already exists",
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          errorMessage: 'An unknown error occurred',
        );
      }
    } catch (error) {
      state = state.copyWith(errorMessage: 'An error occurred: $error');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Uint8List?> compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 150,
      minHeight: 150,
      quality: 20,
    );
    return result;
  }
}
