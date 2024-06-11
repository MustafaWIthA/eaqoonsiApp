import 'package:dio/dio.dart';
import 'package:eaqoonsi/constants.dart';
import 'package:eaqoonsi/providers/dio_provider.dart';
import 'package:eaqoonsi/providers/storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
