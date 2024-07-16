import 'package:eaqoonsi/widget/app_export.dart';

final userVerificationDataProvider = FutureProvider<String>((ref) async {
  final profile = await ref.watch(profileProvider.future);

  final userData = UserVerificationModel(
    userId: profile['id'],
    verificationType: 1,
  );
  final encryptionService = ref.watch(encryptionServiceProvider);
  return encryptionService.encryptData(userData.toJson().toString());
});
