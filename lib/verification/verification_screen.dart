import 'package:eaqoonsi/verification/scan_qr_code_screen.dart';
import 'package:eaqoonsi/verification/show_qr_code.dart';
import 'package:eaqoonsi/verification/history/verification_history_screen.dart';
import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/bottom_nav_bar.dart';

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
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
          iconTheme: IconThemeData(color: EAqoonsiTheme.of(context).alternate),
          backgroundColor: EAqoonsiTheme.of(context).primaryBackground,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: EAqoonsiTheme.of(context).secondary,
            tabs: const <Widget>[
              Tab(
                icon: Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
                text: 'Scan',
              ),
              Tab(
                icon: Icon(Icons.qr_code),
                text: 'Verify QR Code',
              ),
              Tab(
                icon: Icon(Icons.history),
                text: 'History',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(child: QRCodeScannerScreen()),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ShowQrCode(),
              ),
            ),
            Center(
              child: VerificationHistoryScreen(),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
