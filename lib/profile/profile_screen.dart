import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final profileAsyncValue = ref.watch(profileProvider);

    // final authState = ref.watch(authStateProvider);

    // Listen for changes in auth state
    ref.listen<AuthState>(authStateProvider, (previous, current) {
      if (!current.isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });

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
        backgroundColor: kBlueColor,
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

    final sliderItems = [
      {
        'title': 'Digital Credential',
        'description':
            'eAqoonsi provides a verifiable, legal identification credential with the same weight as the National ID card.',
      },
      {
        'title': 'Online & Offline Use',
        'description':
            'Use your digital ID for both online and offline identification needs across various services.',
      },
      {
        'title': 'Secure System',
        'description':
            'eAqoonsi ensures secure online registration using facial recognition, basic information, and OTP verification. Access your account safely with username and password, and utilize QR codes for easy verification.',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (cardResponseDTO != null && cardResponseDTO['mobileIDPdf'] != null)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text(
                        'Digital ID',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: kBlueColor,
                    ),
                    body: PDFViewWidget(
                        base64Pdf: cardResponseDTO['mobileIDPdf']),
                    bottomNavigationBar: const BottomNavBar(),
                  ),
                ),
              );
            },
            child: Container(
              height: 250,
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PDFViewWidget(base64Pdf: cardResponseDTO['mobileIDPdf']),
                  Center(
                    child: Icon(
                      Icons.fullscreen,
                      size: 48,
                      color: Colors.white.withOpacity(0.0),
                    ),
                  ),
                ],
              ),
            ),
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
                  : 'Digital ID card is: $userStatus',
              textAlign: TextAlign.center,
              style: EAqoonsiTheme.of(context).bodyMedium,
            ),
          ),
        const SizedBox(height: 10),
        Text(
          'Personal Details',
          style: EAqoonsiTheme.of(context).titleMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'Latest Information',
          style: EAqoonsiTheme.of(context).titleMedium,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: InfoSlider(items: sliderItems),
        ),
      ],
    );
  }
}

class InfoSlider extends StatefulWidget {
  final List<Map<String, String>> items;

  const InfoSlider({super.key, required this.items});

  @override
  State<InfoSlider> createState() => _InfoSliderState();
}

class _InfoSliderState extends State<InfoSlider> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: EAqoonsiTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.items[index]['title']!,
                    style: EAqoonsiTheme.of(context).titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.items[index]['description']!,
                    style: EAqoonsiTheme.of(context).bodyMedium.copyWith(
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.items.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? EAqoonsiTheme.of(context).primary
                      : EAqoonsiTheme.of(context).secondaryText,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
