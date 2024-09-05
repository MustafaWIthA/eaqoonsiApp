import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class CongratulationBottomSheet extends StatelessWidget {
  const CongratulationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: kBlueColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: kWhiteColor,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Congratulations!',
            style: EAqoonsiTheme.of(context).titleLarge.override(
                  fontFamily: 'Plus Jakarta Sans',
                  color: kWhiteColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Registration has been successful.',
            style: EAqoonsiTheme.of(context).bodyMedium.override(
                  fontFamily: 'Plus Jakarta Sans',
                  color: kWhiteColor,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }
}
