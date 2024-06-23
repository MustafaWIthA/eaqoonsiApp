import 'dart:io';

import 'package:camera/camera.dart';
import 'package:eaqoonsi/login/auth_notifier.dart';
import 'package:eaqoonsi/profile/profile_screen.dart';
import 'package:eaqoonsi/registration/registration_notifier.dart';
import 'package:eaqoonsi/widget/e_aqoonsi_button_widgets.dart';
import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    return CameraPreview(snapshot.data!);
                  } else {
                    return const Center(child: Text('Camera not available'));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
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
                    ref
                        .read(registrationNotifierProvider.notifier)
                        .setCapturedImage(File(imagePath));
                    await ref
                        .read(registrationNotifierProvider.notifier)
                        .register(
                          fullName,
                          email,
                          password,
                          '12345',
                        );
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
