import 'package:eaqoonsi/widget/app_export.dart';

Widget buildLogo() {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 32),
    child: Container(
      width: 200,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: const AlignmentDirectional(0, 0),
      child: Image.asset(
        frontlogoWhite,
        fit: BoxFit.cover,
      ),
    ),
  );
}
