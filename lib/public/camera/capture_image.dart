import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:permission_handler/permission_handler.dart';

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

class CameraScreen extends ConsumerStatefulWidget {
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
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  late Future<void> _cameraPermissionFuture;

  @override
  void initState() {
    super.initState();
    _cameraPermissionFuture = _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Camera permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _cameraPermissionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Camera permission is required to continue.'),
                    ElevatedButton(
                      onPressed: () => _retryPermission(),
                      child: const Text('Request Permission'),
                    ),
                  ],
                ),
              );
            } else {
              return _buildCameraPreview();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    final cameraControllerFuture = ref.watch(cameraControllerProvider.future);

    return Stack(
      children: [
        FutureBuilder<CameraController?>(
          future: cameraControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData && snapshot.data != null) {
                return Column(
                  children: [
                    buildLogo(),
                    const StepIndicator(currentStep: 2, totalSteps: 3),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        border: Border.all(color: kYellowColor, width: 4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: CameraPreview(snapshot.data!),
                    ),
                  ],
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
            onPressed: () => _captureImage(context),
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
    );
  }

  Future<void> _captureImage(BuildContext context) async {
    try {
      final cameraController = await ref.read(cameraControllerProvider.future);
      if (cameraController != null) {
        final image = await cameraController.takePicture();
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImagePreviewScreen(
                widget.fullName,
                widget.email,
                widget.password,
                imagePath: image.path,
              ),
            ),
          );
        }
      } else {
        _showErrorSnackBar('Camera not available');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _retryPermission() async {
    setState(() {
      _cameraPermissionFuture = _requestCameraPermission();
    });
  }

  // @override
  // void dispose() {
  //   ref.read(cameraControllerProvider.notifier).dispose();
  //   super.dispose();
  // }
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

    ref.listen<AuthState>(registrationNotifierProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      } else if (registrationState.errorMessage != null) {
        print(registrationState.errorMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(registrationState.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: kBlueColor,
      body: SafeArea(
        child: Column(
          children: [
            buildLogo(),
            const StepIndicator(currentStep: 1, totalSteps: 3),
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: kYellowColor, width: 4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.file(File(imagePath), fit: BoxFit.fill),
                ),
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
                      ref
                          .read(registrationNotifierProvider.notifier)
                          .setCapturedImage(File(imagePath));
                      await Future.delayed(const Duration(
                          seconds: 1)); // Add a delay for testing

                      await ref
                          .read(registrationNotifierProvider.notifier)
                          .register(
                            fullName,
                            email,
                            password,
                            '12345',
                          );
                    },
                    text: localizations.registerButton,
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
      ),
    );
  }
}
