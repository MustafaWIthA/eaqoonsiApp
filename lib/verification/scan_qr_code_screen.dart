import 'package:eaqoonsi/utilities/encryption_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final scanResultProvider = StateProvider<String>((ref) => '');

class QRCodeScannerScreen extends ConsumerWidget {
  const QRCodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              fit: BoxFit.contain,
              controller: MobileScannerController(
                  facing: CameraFacing.back, returnImage: true),
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    final encryptionService =
                        ref.read(encryptionServiceProvider);
                    try {
                      final decryptedData =
                          encryptionService.decryptData(barcode.rawValue!);
                      print(decryptedData);
                      ref.read(scanResultProvider.notifier).state =
                          decryptedData;
                      Navigator.of(context).pop(); // Return to the main screen
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Invalid QR Code: ${e.toString()}')),
                      );
                    }
                    break;
                  }
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Scan a QR code to verify a user'),
          ),
        ],
      ),
    );
  }
}

class OverLayBackground extends StatelessWidget {
  const OverLayBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [],
    );
  }
}
