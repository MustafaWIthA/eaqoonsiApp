import 'package:eaqoonsi/verification/verify/verify_model.dart';
import 'package:eaqoonsi/widget/app_export.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify User')),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            _processQRCode(barcode.rawValue ?? '');
          }
        },
      ),
    );
  }

  void _processQRCode(String rawValue) async {
    final encryptionService = ref.read(encryptionServiceProvider);
    final dioClient = ref.read(dioProvider);

    try {
      final decryptedData = encryptionService.decryptData(rawValue);
      final qrData = jsonDecode(decryptedData);

      final verificationResponse = await dioClient.verifyUser(
        qrData['userId'],
        qrData['verificationType'],
      );

      _showVerificationResult(verificationResponse);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: ${e.toString()}')),
      );
    }
  }

  void _showVerificationResult(VerificationResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verification Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID Number: ${response.idNumber}'),
              Text('Full Name: ${response.fullName}'),
              const SizedBox(height: 10),
              Image.memory(base64Decode(response.photograph)),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
