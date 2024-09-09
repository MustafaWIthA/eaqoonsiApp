import 'package:eaqoonsi/widget/app_export.dart';

Widget buildLogo() {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 10),
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

Widget buildChangePasswordIcon() {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 10),
    child: Container(
      width: 200,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: const AlignmentDirectional(0, 0),
      child: const Icon(Icons.lock_person_sharp, size: 70, color: kBlueColor),
    ),
  );
}

void showErrorSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: AutoSizeText(
          message,
          textAlign: TextAlign.center, // Center the text
          maxFontSize: 20,
          minFontSize: 14,
          maxLines: 2,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ),
  );
}

void showSuccessSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: AutoSizeText(
          message,
          maxFontSize: 20,
          textAlign: TextAlign.center, // Center the text
          minFontSize: 14,
          maxLines: 2,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: kBlueColor,
      duration: const Duration(seconds: 3),
    ),
  );
}
