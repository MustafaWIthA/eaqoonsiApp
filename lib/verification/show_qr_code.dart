import 'package:eaqoonsi/verification/qr_code_provider.dart';
import 'package:eaqoonsi/widget/app_export.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ShowQrCode extends ConsumerWidget {
  const ShowQrCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrCodeDataAsync = ref.watch(qrCodeProvider);

    return Center(
      child: qrCodeDataAsync.when(
        data: (encryptedData) => Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10),
          child: PrettyQrView.data(
            decoration: const PrettyQrDecoration(
              image: PrettyQrDecorationImage(image: AssetImage(logoBlue)),
            ),
            data: encryptedData,
            // size: 250,
            // roundEdges: true,
          ),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Padding(
          padding: const EdgeInsets.all(18.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${error.toString()}'),
                ElevatedButton(
                  onPressed: () => ref.refresh(qrCodeProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
