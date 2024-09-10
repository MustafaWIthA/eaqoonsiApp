import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/verification/verify/verify_model.dart';
import 'package:eaqoonsi/widget/submit_widget.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class VerificationResultScreen extends StatelessWidget {
  final VerificationResponse response;

  const VerificationResultScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Verification Result',
            style: TextStyle(color: Colors.white),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: EAqoonsiTheme.of(context).primaryBackground,
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildBlueLogo(),
            Text(
              'Verification Successful',
              style: EAqoonsiTheme.of(context).headlineMedium,
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: EAqoonsiTheme.of(context).primary),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    base64Decode(response.photograph),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(response.idNumber, style: EAqoonsiTheme.of(context).bodyLarge),
            Text(response.fullName, style: EAqoonsiTheme.of(context).bodyLarge),
            const SizedBox(height: 24),
            Center(
              child: SubmitButtonWidget(
                  onPressed: () => Navigator.of(context).pop(),
                  buttonText: 'Scan Again'),
            ),
          ],
        ),
      ),
    );
  }
}
