import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class AccountAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final AsyncValue<Map<String, dynamic>> profileAsyncValue;
  final VoidCallback onAvatarTap;

  const AccountAppBar({
    super.key,
    required this.profileAsyncValue,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return AppBar(
      iconTheme: IconThemeData(color: EAqoonsiTheme.of(context).alternate),
      backgroundColor: kBlueColor,
      title: profileAsyncValue.when(
        data: (profile) {
          return AutoSizeText(
            '${localizations.greeting}, ${profile['fullName']}',
            style: EAqoonsiTheme.of(context).titleSmall.override(
                  fontFamily: 'Plus Jakarta Sans',
                  color: EAqoonsiTheme.of(context).alternate,
                  fontSize: 16,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 2,
            minFontSize: 12,
            maxFontSize: 24,
            stepGranularity: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
        loading: () => const Text('Loading...'),
        error: (error, stack) {
          return const Text('Error');
        },
      ),
      actions: [
        InkWell(
          onTap: onAvatarTap,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
