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
          backgroundColor: kBlueColor,
          elevation: 20,
          bottom: TabBar(
            labelColor: kWhiteColor,
            unselectedLabelColor: kWhiteColor.withOpacity(0.7),
            indicatorColor: kYellowColor,
            indicatorWeight: 2,
            tabs: const [
              Tab(icon: Icon(Icons.qr_code), text: 'My QR'),
              Tab(icon: Icon(Icons.camera_alt), text: 'Scan'),
              Tab(icon: Icon(Icons.history), text: 'History'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ShowQrCode(),
            QRCodeScannerScreen(),
            VerificationHistoryScreen(),
          ],
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
