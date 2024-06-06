import 'package:eaqoonsi/help/help_screen.dart';
import 'package:eaqoonsi/profile/profile_screen.dart';
import 'package:eaqoonsi/verification/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return BottomNavigationBar(
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
          icon: Icon(Icons.verified),
          label: 'Verification',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.help),
          label: 'Help',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: EAqoonsiTheme.of(context).primary,
      unselectedItemColor: EAqoonsiTheme.of(context).darkBackground,
      unselectedLabelStyle: EAqoonsiTheme.of(context).titleSmall.override(
            fontFamily: 'Plus Jakarta Sans',
            color: EAqoonsiTheme.of(context).primaryText,
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
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
              routeName = const ProfileScreen();
              break;
            case 2:
              routeName = const VerificationScreen();
              break;
            case 3:
              routeName = const HelpScreen();
              break;
            default:
              routeName = const ProfileScreen();
          }
          Navigator.pushReplacement(
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