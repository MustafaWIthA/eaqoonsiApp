import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QrCodeScanner extends ConsumerStatefulWidget {
  const QrCodeScanner({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends ConsumerState<QrCodeScanner> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
