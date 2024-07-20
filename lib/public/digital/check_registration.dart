import 'package:dio/dio.dart';
import 'package:eaqoonsi/constants.dart';
import 'package:eaqoonsi/public/login/login_screen.dart';
import 'package:eaqoonsi/otp/verify_otp.dart';
import 'package:eaqoonsi/registration/registration_notifier.dart';
import 'package:eaqoonsi/widget/animation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/e_aqoonsi_button_widgets.dart';
import '../../widget/text_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final otpIdProvider = StateProvider<String?>((ref) => null);

class CheckNationalIDNumber extends ConsumerStatefulWidget {
  const CheckNationalIDNumber({super.key});

  @override
  ConsumerState<CheckNationalIDNumber> createState() =>
      _CheckNationalIDNumberState();
}

class _CheckNationalIDNumberState extends ConsumerState<CheckNationalIDNumber>
    with TickerProviderStateMixin {
  final animationsMap = <String, AnimationInfo>{};
  final nationalIDNumberController = TextEditingController();
  final nationalIDNumberFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    animationsMap['containerOnPageLoadAnimation'] = AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
        TiltEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 400.ms,
          begin: Offset(0, 0.524),
          end: Offset(0, 0),
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 400.ms,
          begin: Offset(70, 0),
          end: Offset(0, 0),
        ),
      ],
    );
  }

  Future<void> checkNationalIDNumber() async {
    final localizations = AppLocalizations.of(context)!;
    final idNumber = nationalIDNumberController.text;

    try {
      final dio = Dio(BaseOptions(
        validateStatus: (status) => status! < 500,
      ));

      final response = await dio.get(
        "$kDigitalSearchUrl/$idNumber",
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      _handleApiResponse(response.data, localizations);
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  void _handleApiResponse(
      Map<String, dynamic> data, AppLocalizations localizations) {
    switch (data['statusCode']) {
      case 200:
        _handleSuccessResponse(data);
        break;
      case 409:
        _showErrorSnackBar(data['message']);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
        break;
      case 400:
      case 404:
        _showErrorSnackBar(localizations.invalidNationalIDNumber);
        break;
      default:
        _showErrorSnackBar('Unexpected response: ${data['statusCode']}');
    }
  }

  void _handleSuccessResponse(Map<String, dynamic> data) {
    ref.read(otpIdProvider.notifier).state = data['otPid'];
    final otpId = data['otPid'];
    final phoneNumber = data['data']['phone'];
    ref
        .read(registrationNotifierProvider.notifier)
        .setUserName(nationalIDNumberController.text);

    if (otpId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              VerifyOTPWidget(otpId: otpId, phoneNumber: phoneNumber),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return MaterialApp(
      home: GestureDetector(
        child: Scaffold(
          backgroundColor: EAqoonsiTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLogo(),
                            _buildInputContainer(localizations),
                          ],
                        ),
                      ).animateOnPageLoad(
                          animationsMap['containerOnPageLoadAnimation']!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
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

  Widget _buildInputContainer(AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 570,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: const AlignmentDirectional(0, 0),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.verifyNationalIDNumber,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF4B39EF),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildNationalIDInput(localizations),
              _buildSubmitButton(localizations),
              _buildLoginLink(localizations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNationalIDInput(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 16),
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
          controller: nationalIDNumberController,
          focusNode: nationalIDNumberFocusNode,
          textInputAction: TextInputAction.send,
          obscureText: false,
          maxLength: 11,
          decoration: InputDecoration(
            labelText: localizations.verifyNationalIDNumberLabel,
            labelStyle: const TextStyle(
              color: Color(0xFF57636C),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            hintText: localizations.verifyNationalIDNumberHintText,
            hintStyle: const TextStyle(
              color: Color(0xFF57636C),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFF1F4F8),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF4B39EF),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFE0E3E7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFE0E3E7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: const Color(0xFFF1F4F8),
          ),
          style: EAqoonsiTheme.of(context).bodyLarge.override(
                fontFamily: 'Plus Jakarta Sans',
                color: const Color(0xFF101213),
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.invalidNationalIDNumber;
            } else if (value.length < 11) {
              return localizations.invalidNationalIDNumber;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildSubmitButton(AppLocalizations localizations) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
        child: EaqoonsiButtonWidget(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              checkNationalIDNumber();
            }
          },
          text: localizations.checkButton,
          options: EaqoonsiButtonOptions(
            width: 230,
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
    );
  }

  Widget _buildLoginLink(AppLocalizations localizations) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
        child: RichText(
          textScaler: MediaQuery.of(context).textScaler,
          text: TextSpan(
            children: [
              TextSpan(
                text: localizations.haveanaccount,
                style: const TextStyle(),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    localizations.loginButton,
                    style: const TextStyle(
                      color: Color(0xFF4B39EF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
            style: const TextStyle(
              color: Color(0xFF57636C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
