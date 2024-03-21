// import 'package:eaqoonsi/widget/eaqoonsi_text_from_field.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class BasicInfo extends ConsumerStatefulWidget {
//   const BasicInfo(fullName, email, password, {super.key});

//   @override
//   ConsumerState<BasicInfo> createState() => _BasicInfoState();
// }

// class _BasicInfoState extends ConsumerState<BasicInfo> {
//   final fullName = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
//           child: SizedBox(
//             width: double.infinity,
//             child: EaqoonsiTextFormField(
//               controller: fullName,
//               autofocus: true,
//               focusNode: fullNameFocusNode,
//               labelText: 'Full Name',
//               hintText: 'Enter your full name',
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
//           child: SizedBox(
//             width: double.infinity,
//             child: EaqoonsiTextFormField(
//               controller: email,
//               focusNode: emailFocusNode,
//               labelText: 'Email',
//               hintText: 'Enter your email',
//               keyboardType: TextInputType.emailAddress,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
//           child: SizedBox(
//             width: double.infinity,
//             child: EaqoonsiTextFormField(
//               controller: password,
//               focusNode: passwordFocusNode,
//               labelText: 'Password',
//               hintText: 'Enter your password',
//               obscureText: true,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
