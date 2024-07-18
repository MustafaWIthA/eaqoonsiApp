import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final profileAsyncValue = ref.watch(profileProvider);

    void logout() async {
      ref.read(authStateProvider.notifier).logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
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
        onRefresh: () =>
            ref.read(profileNotifierProvider.notifier).refreshProfile(),
        child: profileAsyncValue.when(
          data: (profile) => ProfileContent(profile: profile),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final Map<String, dynamic> profile;

  const ProfileContent({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final cardResponseDTO = profile['cardResponseDTO'];
    final userStatus = profile['userStatus'];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (cardResponseDTO != null && cardResponseDTO['mobileIDPdf'] != null)
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: EAqoonsiTheme.of(context).alternate,
              boxShadow: const [
                BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(0, 2))
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: PDFViewWidget(base64Pdf: cardResponseDTO['mobileIDPdf']),
          )
        else
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: EAqoonsiTheme.of(context).alternate,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              userStatus == 'ACTIVE'
                  ? 'Digital ID card not available'
                  : 'Digital ID card not available. Account status: $userStatus',
              textAlign: TextAlign.center,
              style: EAqoonsiTheme.of(context).bodyMedium,
            ),
          ),
        const SizedBox(height: 10),
        const Text('Personal Details'),
        const SizedBox(height: 10),
        const Text('Slider latest info'),
      ],
    );
  }
}
