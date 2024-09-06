//create consumer stateful widget
import 'package:eaqoonsi/widget/app_export.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: kBlueColor,
      appBar: AccountAppBar(
        profileAsyncValue: profileAsyncValue,
        onAvatarTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AccountScreen()),
          );
        },
      ),
      body: const Text('Settings Screen'),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
