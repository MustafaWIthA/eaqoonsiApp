import 'package:eaqoonsi/widget/app_export.dart';
import 'package:intl/intl.dart';

class VerificationHistoryScreen extends ConsumerWidget {
  const VerificationHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsyncValue = ref.watch(verificationHistoryProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(verificationHistoryProvider.future),
        child: historyAsyncValue.when(
          data: (history) => _buildHistoryList(history),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
              child: Text(
            'Error: $error',
            // style: AppStyle.txtBodyMedium,
          )),
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<VerificationHistoryModel> history) {
    if (history.isEmpty) {
      return const Center(
        child: Text(
          'You have no verifications yet.',
          // style: AppStyle.txtBodyLarge,
        ),
      );
    }

    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(
              'You have been Verified by: ${item.username}',
              // style: AppStyle.txtBodyLarge,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(item.verifiedAt)}',
                  // style: AppStyle.txtBodyMedium,
                ),
                Text(
                  'Type: ${item.verificationType}',
                  // style: AppStyle.txtBodySmall
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
