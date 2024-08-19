import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/verification/verify/verify_model.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class VerificationResultScreen extends StatelessWidget {
  final VerificationResponse response;

  const VerificationResultScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Result'),
        backgroundColor: EAqoonsiTheme.of(context).primaryBackground,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verification Successful',
                style: EAqoonsiTheme.of(context).headlineMedium,
              ),
              const SizedBox(height: 24),
              Text('ID Number: ${response.idNumber}',
                  style: EAqoonsiTheme.of(context).bodyLarge),
              const SizedBox(height: 8),
              Text('Full Name: ${response.fullName}',
                  style: EAqoonsiTheme.of(context).bodyLarge),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: EAqoonsiTheme.of(context).primary),
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
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Scan Another'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
