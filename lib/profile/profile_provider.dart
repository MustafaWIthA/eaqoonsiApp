import 'package:eaqoonsi/widget/app_export.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dio = ref.read(dioProvider);
  final storage = ref.read(storageProvider);
  final token = await storage.read(key: 'access_token');

  try {
    final response = await dio.get(
      kProfileUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print("i am here");

    //depug response
    print(response.data['cardResponseDTO']);

    return response.data;
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      ref.read(authStateProvider.notifier).logout();
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load profile');
    }
  }
});
