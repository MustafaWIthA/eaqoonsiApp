import 'package:eaqoonsi/widget/app_export.dart';

final storageProvider =
    Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(dioProvider), ref.read(storageProvider));
});
