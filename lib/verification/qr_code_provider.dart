import 'package:eaqoonsi/verification/qr_codedata_model.dart';
import 'package:eaqoonsi/widget/app_export.dart';

final qrCodeProvider = FutureProvider<String>((ref) async {
  try {
    final profile = await ref.watch(profileProvider.future);
    final encryptionService = ref.watch(encryptionServiceProvider);

    final qrCodeData = QRCodeDataModel(
      userId: profile['id'],
      verificationType: 0, // Assuming 0 is the default verification type
    );

    final jsonData = jsonEncode(qrCodeData.toJson());
    return encryptionService.encryptData(jsonData);
  } catch (e) {
    throw Exception('Failed to generate QR code: ${e.toString()}');
  }
});
