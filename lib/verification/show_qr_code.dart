import 'package:eaqoonsi/verification/user_verfication_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ShowQrCode extends ConsumerWidget {
  const ShowQrCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final encryptedDataAsync = ref.watch(userVerificationDataProvider);

    return encryptedDataAsync.when(
      data: (encryptedData) => Center(
        child: PrettyQrView.data(
          data: encryptedData,
          // size: 200,
          // roundEdges: true,
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
