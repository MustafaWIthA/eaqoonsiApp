// import 'package:eaqoonsi/widget/app_export.dart';

// final loginProvider = FutureProvider.family<LoginResponse, LoginCredentials>(
//     (ref, credentials) async {
//   final dioClient = ref.read(dioProvider);
//   try {
//     final response = await dioClient.post(
//       '/auth/login',
//       data: {
//         'username': credentials.username,
//         'password': credentials.password,
//       },
//     );