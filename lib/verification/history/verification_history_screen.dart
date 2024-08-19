import 'package:eaqoonsi/widget/app_export.dart';
import 'package:intl/intl.dart';

class VerificationHistoryScreen extends ConsumerWidget {
  const VerificationHistoryScreen({super.key});

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${error.toString()}'),
                ElevatedButton(
                  onPressed: () => ref.refresh(verificationHistoryProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<VerificationHistoryModel> history) {
    if (history.isEmpty) {
      return const Center(
        child: Text('No verification history available.'),
      );
    }

    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text('Verified by: ${item.verifiedBy}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ${item.username}'),
                Text(
                    'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(item.verifiedAt)}'),
                Text('Type: ${item.verificationType}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
