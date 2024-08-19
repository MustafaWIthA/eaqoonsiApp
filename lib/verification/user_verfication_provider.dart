import 'package:eaqoonsi/widget/app_export.dart';

final verificationHistoryProvider =
    FutureProvider<List<VerificationHistoryModel>>((ref) async {
  final dioClient = ref.read(dioProvider);

  try {
    final response = await dioClient.get('/verification/history');
    final List<dynamic> data = response.data;
    return data.map((item) => VerificationHistoryModel.fromJson(item)).toList();
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      ref.read(authStateProvider.notifier).logout();
      throw UnauthorizedException('Session expired. Please log in again.');
    } else {
      throw Exception('Failed to load verification history: ${e.message}');
    }
  }
});
