import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);

    // final authState = ref.watch(authStateProvider);
    //check if the profileAsyncValue
    if (profileAsyncValue is AsyncData && profileAsyncValue.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authStateProvider.notifier).logout();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }

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
      appBar: AccountAppBar(
        profileAsyncValue: profileAsyncValue,
        onAvatarTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AccountScreen()),
          );
        },
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
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
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
        const AutoSizeText(
          'Digital ID Card',
          maxFontSize: 24,
          minFontSize: 16,
          style: TextStyle(
            color: kBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (cardResponseDTO != null && cardResponseDTO['mobileIDPdf'] != null)
          ClickablePDFPreview(
            base64Pdf: cardResponseDTO['mobileIDPdf'],
            height: 250,
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
        const SizedBox(height: 30),
        const AutoSizeText(
          'Useful Information',
          maxFontSize: 24,
          minFontSize: 16,
          style: TextStyle(
            color: kBlueColor,
            fontWeight: FontWeight.bold,
          ),
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
