import 'package:eaqoonsi/providers/storage_provider.dart';
import 'package:eaqoonsi/widget/app_export.dart';

final verificationHistoryProvider =
    FutureProvider<List<VerificationHistoryModel>>((ref) async {
  final dio = ref.read(dioProvider);
  final storage = ref.read(storageProvider);
  final token = await storage.read(key: 'access_token');
  print(token);

  try {
    print("maxaa doonaysa");
    print(token);

    final response = await dio.get(
      kVerifictionHistoryUrl,
    );

    print("Verification History Response: ${response.data}");

    final List<dynamic> data = response.data;
    return data.map((item) => VerificationHistoryModel.fromJson(item)).toList();
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      //  ref.read(authStateProvider.notifier).logout();
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load verification history');
    }
  }
});
