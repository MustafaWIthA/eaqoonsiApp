import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:eaqoonsi/login/auth_notifier.dart';
import 'package:eaqoonsi/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dio = ref.read(dioProvider);
  final storage = ref.read(storageProvider);
  final token = await storage.read(key: 'access_token');

  try {
    final response = await dio.get(
      'http://10.0.2.2:9191/api/v1/profile',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return response.data;
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      ref.read(authStateProvider.notifier).logout();
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load profile');
    }
  }
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final profileAsyncValue = ref.watch(profileProvider);

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Profile', style: EAqoonsiTheme.of(context).titleLarge),
        actions: [
          InkWell(
            onTap: () {
              // Add your onTap functionality here
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Color.fromARGB(255, 76, 61, 61),
                child: Icon(Icons.person, size: 20, color: Colors.white),
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
      body: profileAsyncValue.when(
        data: (profile) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}
