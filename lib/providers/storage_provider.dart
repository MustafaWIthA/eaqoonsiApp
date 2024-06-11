import 'package:eaqoonsi/login/auth_notifier.dart';
import 'package:eaqoonsi/providers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storageProvider =
    Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(dioProvider), ref.read(storageProvider));
});
