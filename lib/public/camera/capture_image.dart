import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

final cameraControllerProvider = FutureProvider<CameraController?>((ref) async {
  final cameras = await availableCameras();
  if (cameras.isEmpty) {
    return null;
  }
  final frontCamera = cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.front,
    orElse: () => cameras.first,
  );
  final controller = CameraController(frontCamera, ResolutionPreset.medium);
  await controller.initialize();
  return controller;
});

class CameraScreen extends ConsumerWidget {
  final String fullName;
  final String email;
  final String password;
  const CameraScreen({
    required this.fullName,
    required this.email,
    required this.password,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraControllerFuture = ref.watch(cameraControllerProvider.future);

    return Scaffold(
      backgroundColor: kBlueColor,
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<CameraController?>(
              future: cameraControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    return Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: kYellowColor, width: 4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CameraPreview(snapshot.data!),
                      ),
                    );
                  } else {
                    return const Center(child: Text('Camera not available'));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: EaqoonsiButtonWidget(
                onPressed: () async {
                  try {
                    final cameraController =
                        await ref.read(cameraControllerProvider.future);
                    if (cameraController != null) {
                      final image = await cameraController.takePicture();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImagePreviewScreen(
                            fullName,
                            email,
                            password,
                            imagePath: image.path,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Camera not available')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                text: 'Capture',
                options: EaqoonsiButtonOptions(
                  width: 130,
                  height: 52,
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
            ),
          ],
        ),
      ),
    );
  }
}

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
    final dioClient = ref.watch(dioProvider);

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

class CongratulationBottomSheet extends StatelessWidget {
  const CongratulationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: kBlueColor,
        borderRadius: const BorderRadius.only(
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
