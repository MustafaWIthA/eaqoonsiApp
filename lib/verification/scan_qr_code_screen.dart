import 'package:eaqoonsi/verification/verify/verify_model.dart';
import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScannerScreen extends ConsumerStatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends ConsumerState<QRCodeScannerScreen> {
  bool _isVerifying = false;
  bool _qrDetected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: EAqoonsiTheme.of(context).primaryBackground,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: MobileScanner(
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null && !_isVerifying) {
                        _processQRCode(context, ref, barcode.rawValue!);
                        break;
                      }
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _qrDetected
                      ? 'QR Code detected! Verifying...'
                      : 'Scan a QR code to verify a user',
                  style: EAqoonsiTheme.of(context).bodyMedium,
                ),
              ),
            ],
          ),
          if (_isVerifying)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                        color: EAqoonsiTheme.of(context).primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      'Verifying...',
                      style: EAqoonsiTheme.of(context)
                          .bodyMedium
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _processQRCode(BuildContext context, WidgetRef ref, String rawValue) {
    if (_isVerifying) return;
    setState(() {
      _qrDetected = true;
      _isVerifying = true;
    });

    final encryptionService = ref.read(encryptionServiceProvider);
    try {
      final decryptedData = encryptionService.decryptData(rawValue);
      final verificationData = jsonDecode(decryptedData);
      _initiateVerification(context, ref, verificationData);
    } catch (e) {
      print('Decryption error: $e'); // For debugging
      _showErrorSnackBar('Invalid QR Code: Unable to process the data');
      _resetState();
    }
  }

  void _initiateVerification(BuildContext context, WidgetRef ref,
      Map<String, dynamic> verificationData) async {
    final dioClient = ref.read(dioProvider);
    try {
      final response = await dioClient.verifyUser(
        verificationData['userId'],
        verificationData['verificationType'],
      );
      if (mounted) {
        _showVerificationResult(context, response);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Verification failed: ${e.toString()}');
      }
    } finally {
      _resetState();
    }
  }

  void _resetState() {
    if (mounted) {
      setState(() {
        _isVerifying = false;
        _qrDetected = false;
      });
    }
  }

  void _showVerificationResult(
      BuildContext context, VerificationResponse response) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: EAqoonsiTheme.of(context).primaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verification Result',
                style: EAqoonsiTheme.of(context).titleMedium,
              ),
              const SizedBox(height: 16),
              Text('ID Number: ${response.idNumber}',
                  style: EAqoonsiTheme.of(context).bodyMedium),
              Text('Full Name: ${response.fullName}',
                  style: EAqoonsiTheme.of(context).bodyMedium),
              const SizedBox(height: 16),
              Center(child: Image.memory(base64Decode(response.photograph))),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) => _resetState());
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
