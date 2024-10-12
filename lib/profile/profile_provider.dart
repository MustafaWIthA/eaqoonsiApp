import 'package:eaqoonsi/widget/app_export.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dioClient = ref.read(dioProvider);

  try {
    final response = await dioClient.get('/profile');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      ref.read(authStateProvider.notifier).logout();
      throw UnauthorizedException('Unauthorized access. Please log in again.');
    }
  } on UnauthorizedException {
    ref.read(authStateProvider.notifier).logout();
    throw Exception('Unauthorized access. Please log in again.');
  } on ApiException catch (e) {
    print(e);
    throw Exception(e.message ?? 'Failed to load profile');
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
