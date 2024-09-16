import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:intl/intl.dart';

class VerificationHistoryScreen extends ConsumerWidget {
  const VerificationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsyncValue = ref.watch(verificationHistoryProvider);
    final connectivity = ref.watch(connectivityProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: EAqoonsiTheme.of(context).alternate),
        backgroundColor: kBlueColor,
        title: Text(
          'Verification History',
          style: EAqoonsiTheme.of(context).titleSmall.override(
                fontFamily: 'Plus Jakarta Sans',
                color: EAqoonsiTheme.of(context).alternate,
                fontSize: 16,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      body: StreamBuilder<List<ConnectivityResult>>(
        stream: connectivity.onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              !snapshot.data!.contains(ConnectivityResult.mobile) &&
              !snapshot.data!.contains(ConnectivityResult.wifi)) {
            return _buildNoInternetWidget(context, ref);
          }
          return RefreshIndicator(
            onRefresh: () async {
              try {
                await ref.refresh(verificationHistoryProvider.future);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to refresh: ${e.toString()}')),
                );
              }
            },
            child: historyAsyncValue.when(
              data: (history) => _buildHistoryList(history),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorWidget(context, error, ref),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
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

  Widget _buildErrorWidget(BuildContext context, Object error, WidgetRef ref) {
    String errorMessage = 'An error occurred';
    if (error is NetworkException) {
      errorMessage = 'No internet connection';
    } else if (error is ApiException) {
      errorMessage = error.toString();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage),
          ElevatedButton(
            onPressed: () => ref.refresh(verificationHistoryProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoInternetWidget(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No internet connection'),
          ElevatedButton(
            onPressed: () => ref.refresh(verificationHistoryProvider),
            child: const Text('Retry when online'),
          ),
        ],
      ),
    );
  }
}
