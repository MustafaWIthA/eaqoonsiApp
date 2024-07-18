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
    return response.data;
  } catch (e) {
    throw Exception('Failed to load profile');
  }
});

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<Map<String, dynamic>>>(
        (ref) {
  return ProfileNotifier(ref);
});

class ProfileNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref _ref;
  ProfileNotifier(this._ref) : super(const AsyncValue.loading()) {
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _ref.read(profileProvider.future);
      state = AsyncValue.data(profile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshProfile() async {
    await _ref.refresh(profileProvider);
    await _fetchProfile();
  }
}
