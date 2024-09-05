import 'package:eaqoonsi/registration/dio_providers.dart';
import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class ImagePreviewScreen extends ConsumerWidget {
  final String imagePath;
  final String fullName;
  final String email;
  final String password;

  const ImagePreviewScreen(this.fullName, this.email, this.password,
      {required this.imagePath, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final registrationState = ref.watch(registrationNotifierProvider);
    final dioClient = ref.watch(dioProviders);

    ref.listen<AuthState>(registrationNotifierProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      } else if (registrationState.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(registrationState.errorMessage!),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Image')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.file(File(imagePath)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EaqoonsiButtonWidget(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: localizations.takePhoto,
                  options: EaqoonsiButtonOptions(
                    width: 130,
                    height: 52,
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: EAqoonsiTheme.of(context).secondaryBackground,
                    textStyle: EAqoonsiTheme.of(context).titleSmall.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Colors.black,
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                    elevation: 3,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  showLoadingIndicator: true,
                ),
                EaqoonsiButtonWidget(
                  onPressed: () async {
                    try {
                      final formData = FormData.fromMap({
                        'username': fullName,
                        'photo': await MultipartFile.fromFile(imagePath,
                            filename: 'image.jpg'),
                        'fullName': fullName,
                        'email': email,
                        'password': password,
                      });

                      print('formData: $formData');

                      final response = await dioClient.post(
                        '/auth/registration',
                        data: formData,
                      );

                      if (response.statusCode == 200) {
                        ref
                            .read(authStateProvider.notifier)
                            .login(email, password);
                      } else {
                        throw Exception('Registration failed');
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  text: localizations.sendPhoto,
                  options: EaqoonsiButtonOptions(
                    width: 130,
                    height: 52,
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: EAqoonsiTheme.of(context).primaryBackground,
                    textStyle: EAqoonsiTheme.of(context).titleSmall.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                    elevation: 3,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  showLoadingIndicator: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
