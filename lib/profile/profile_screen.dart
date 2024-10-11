import 'package:eaqoonsi/widget/app_export.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);
    final localization = AppLocalizations.of(context)!;

    if (profileAsyncValue is AsyncData && profileAsyncValue.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authStateProvider.notifier).logout();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
    @override
    void initState() {
      super.initState();
      ref.invalidate(profileProvider);
    }

    ref.listen<AuthState>(authStateProvider, (previous, current) {
      if (!current.isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });

    void logout() async {
      if (!mounted) return;
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
          ref.read(selectedIndexProvider.notifier).state = 1;
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
              decoration: const BoxDecoration(color: kBlueColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add the logo widget
                  Image.asset(
                    frontlogoWhite,
                    width: MediaQuery.of(context).size.width * 0.9,
                    // height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: Text(localization.changePassword),
              onTap: () {
                ref.read(selectedIndexProvider.notifier).state = 1;
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(localization.logout),
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
          error: (error, stack) {
            if (error is ForbiddenException) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Access denied. Please refresh or logout.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Refresh the profile
                        ref
                            .read(profileNotifierProvider.notifier)
                            .refreshProfile();
                      },
                      child: const Text('Refresh'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Logout the user
                        ref.read(authStateProvider.notifier).logout();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            } else if (error is UnauthorizedException) {
              return const Center(
                child: Text('Please log in again.'),
              );
            } else {
              return Center(
                child: Text('Error: ${error.toString()}'),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
