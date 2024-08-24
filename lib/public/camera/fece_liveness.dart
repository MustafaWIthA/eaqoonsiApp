// import 'package:flutter/material.dart';
// import 'package:flutter_face_api/flutter_face_api.dart';
// import 'package:flutter/services.dart';

// class FaceLivenessWidget extends StatefulWidget {
//   const FaceLivenessWidget({super.key});

//   @override
//   State<FaceLivenessWidget> createState() => _FaceLivenessWidgetState();
// }

// class _FaceLivenessWidgetState extends State<FaceLivenessWidget> {
//   final FaceSDK _faceSdk = FaceSDK.instance;
//   String _status = "Not initialized";
//   String _livenessStatus = "Not tested";
//   Image? _capturedImage;

//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     setState(() {
//       _status = "Initializing...";
//     });
//     var license = await _loadAssetIfExists("assets/regula.license");
//     InitConfig? config = license != null ? InitConfig(license) : null;
//     var (success, error) = await _faceSdk.initialize(config: config);
//     if (!success) {
//       setState(() {
//         _status = "Error: ${error!.message}";
//       });
//       print("${error?.code}: ${error?.message}");
//     } else {
//       setState(() {
//         _status = "Ready";
//       });
//     }
//   }

//   Future<ByteData?> _loadAssetIfExists(String path) async {
//     try {
//       return await rootBundle.load(path);
//     } catch (_) {
//       return null;
//     }
//   }

//   Future<void> _startLivenessCheck() async {
//     setState(() {
//       _status = "Checking liveness...";
//     });
//     var result = await _faceSdk.startLiveness(
//       config: LivenessConfig(skipStep: [LivenessSkipStep.ONBOARDING_STEP]),
//       notificationCompletion: (notification) {
//         print(notification.status);
//       },
//     );
//     if (result.image != null) {
//       setState(() {
//         _capturedImage = Image.memory(result.image!);
//         _livenessStatus = result.liveness.name.toLowerCase();
//         _status = "Ready";
//       });
//     } else {
//       setState(() {
//         _status = "Failed to capture image";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Face Liveness Check')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Status: $_status'),
//             Text('Liveness Status: $_livenessStatus'),
//             ElevatedButton(
//               onPressed: _status == "Ready" ? _startLivenessCheck : null,
//               child: const Text('Start Liveness Check'),
//             ),
//             if (_capturedImage != null)
//               Container(
//                 margin: const EdgeInsets.only(top: 20),
//                 child: Image(image: _capturedImage!.image),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
