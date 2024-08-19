import 'package:eaqoonsi/verification/scan_qr_code_screen.dart';
import 'package:eaqoonsi/verification/show_qr_code.dart';
import 'package:eaqoonsi/verification/history/verification_history_screen.dart';
import 'package:eaqoonsi/widget/app_export.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verification'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.camera_alt), text: 'Scan'),
              Tab(icon: Icon(Icons.qr_code), text: 'My QR'),
              Tab(icon: Icon(Icons.history), text: 'History'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            QRCodeScannerScreen(),
            ShowQrCode(),
            VerificationHistoryScreen(),
          ],
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
