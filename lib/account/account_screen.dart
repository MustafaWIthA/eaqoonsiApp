import 'package:eaqoonsi/account/digital_id_card_dynamic.dart';
import 'package:eaqoonsi/widget/app_export.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(profileProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: profileAsyncValue.when(
            data: (profileData) => DigitalIDCard(profileData: profileData),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
