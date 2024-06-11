import 'dart:convert';
import 'dart:typed_data';

import 'package:eaqoonsi/providers/storage_provider.dart';
import 'package:eaqoonsi/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:eaqoonsi/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/profile/profile_provider.dart';

// DEFINE THE PROVIDER HERE

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final profileAsyncValue = ref.watch(profileProvider);

    Future<void> _refreshProfile() async {
      await ref.refresh(profileProvider.future);
    }

    void logout() {
      ref.read(authStateProvider.notifier).logout();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }

    return Scaffold(
      backgroundColor: EAqoonsiTheme.of(context).primaryBackground,
      appBar: AppBar(
        iconTheme: IconThemeData(color: EAqoonsiTheme.of(context).alternate),
        backgroundColor: EAqoonsiTheme.of(context).primaryBackground,
        title: profileAsyncValue.when(
          data: (profile) {
            return Text(
              '${localizations.greeting}, ${profile['fullName']}',
              style: EAqoonsiTheme.of(context).titleSmall.override(
                    fontFamily: 'Plus Jakarta Sans',
                    color: EAqoonsiTheme.of(context).alternate,
                    fontSize: 16,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w500,
                  ),
            );
          },
          loading: () => const Text('Loading...'),
          error: (error, stack) {
            return const Text('Error');
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              // tap profile
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: profileAsyncValue.when(
                data: (profile) {
                  String base64Image = profile['photo'];
                  Uint8List imageBytes = base64Decode(base64Image);
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: EAqoonsiTheme.of(context).primary,
                    backgroundImage:
                        imageBytes.isNotEmpty ? MemoryImage(imageBytes) : null,
                    child: imageBytes.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          )
                        : null,
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: profileAsyncValue.when(
          data: (profile) {
            String base64Image = profile['photo'];
            Uint8List imageBytes = base64Decode(base64Image);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    '${localizations.greeting}, ${profile['fullName']}',
                    style: EAqoonsiTheme.of(context).titleSmall.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: EAqoonsiTheme.of(context).primary,
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    decoration: BoxDecoration(
                      color: EAqoonsiTheme.of(context).alternate,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x33000000),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: const AlignmentDirectional(0, -1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Email: ${profile['email']}',
                            style: EAqoonsiTheme.of(context).bodyText1.override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: EAqoonsiTheme.of(context).primary,
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: EAqoonsiTheme.of(context).primary,
                            backgroundImage: imageBytes.isNotEmpty
                                ? MemoryImage(imageBytes)
                                : null,
                            child: imageBytes.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            if (error.toString() == 'Exception: Unauthorized') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              });
            }
            return Center(child: Text('Error: $error'));
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
