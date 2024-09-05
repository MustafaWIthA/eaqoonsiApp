import 'package:eaqoonsi/verification/verification_show_result.dart';
import 'package:eaqoonsi/verification/verify/verify_model.dart';
import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScannerScreen extends ConsumerStatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  ConsumerState<QRCodeScannerScreen> createState() =>
      _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends ConsumerState<QRCodeScannerScreen> {
  bool _isVerifying = false;
  bool _qrDetected = false;
  late MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: EAqoonsiTheme.of(context).alternate),
        backgroundColor: kBlueColor,
        title: Text(
          'Scan eAqoonsi Digital',
          style: EAqoonsiTheme.of(context).titleSmall.override(
                fontFamily: 'Plus Jakarta Sans',
                color: EAqoonsiTheme.of(context).alternate,
                fontSize: 16,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: MobileScanner(
                  controller: _scannerController,
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
                        color: EAqoonsiTheme.of(context).primary),
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
      bottomNavigationBar: const BottomNavBar(),
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
      print('Decrypted data: $decryptedData'); // For debugging

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
        _navigateToVerificationResult(context, response);
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

  void _navigateToVerificationResult(
      BuildContext context, VerificationResponse response) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => VerificationResultScreen(response: response),
      ),
    )
        .then((_) {
      // Resume scanning when returning from the result screen
      _scannerController.start();
    });
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
