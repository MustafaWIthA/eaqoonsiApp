import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 241, 242, 242),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kBlueColor,
      unselectedItemColor: EAqoonsiTheme.of(context).secondaryText,
      unselectedLabelStyle: EAqoonsiTheme.of(context).titleSmall.override(
            fontFamily: 'Plus Jakarta Sans',
            color: EAqoonsiTheme.of(context).secondaryText,
            letterSpacing: 0,
            fontWeight: FontWeight.w400,
          ),
      selectedLabelStyle: EAqoonsiTheme.of(context).titleSmall.override(
            fontFamily: 'Plus Jakarta Sans',
            color: kBlueColor,
            letterSpacing: 0,
            fontWeight: FontWeight.w900,
          ),
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index != selectedIndex) {
          ref.read(selectedIndexProvider.notifier).state = index;
          Widget routeName;
          switch (index) {
            case 0:
              routeName = const ProfileScreen();
              break;
            case 1:
              routeName = const AccountScreen();
              break;
            // case 2:
            //   routeName = const VerificationScreen();
            //   break;
            case 2:
              routeName = const QRCodeScannerScreen();
              break;
            // case 3:
            //   routeName = const ShowQrCode();
            //   break;

            case 3:
              routeName = const VerificationHistoryScreen();
              break;

            default:
              routeName = const ProfileScreen();
          }

          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => routeName,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      },
      elevation: 0,
    );
  }
}
