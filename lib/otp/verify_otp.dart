import 'package:dio/dio.dart';
import 'package:eaqoonsi/registration/registration_screen.dart';
import 'package:eaqoonsi/widget/animation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widget/e_aqoonsi_button_widgets.dart';
import '../widget/text_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyOTPWidget extends StatefulWidget {
  final String phoneNumber;
  final String otpId;
  final String? nationalIDNumberController;

  const VerifyOTPWidget({
    required this.phoneNumber,
    required this.otpId,
    super.key,
    this.nationalIDNumberController,
  });

  @override
  State<VerifyOTPWidget> createState() => _VerifyOTPWidgetState();
}

class _VerifyOTPWidgetState extends State<VerifyOTPWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};
  final otpCodeController = TextEditingController();
  //otpCodeControllerValidator

  //validate the otp code localhost:9193/api/v1/otp/validate
  Future<void> validateOTP() async {
    //validate the pin code
    print(otpCodeController.text);
    try {
      final dio = Dio();
      final response = await dio.post(
        'http://10.0.2.2:9193/api/v1/otp/validate',
        data: {
          'otpId': widget.otpId,
          'token': otpCodeController.text,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print(otpCodeController.text);
      //if the pin code is correct

      print(response.data['statusCodeValue']);
      print("otp");

      if (response.statusCode == 200) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RegistrationScreen(),
          ),
        );
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                "Invalid OTP Code",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }

      //validate with the backend
      //if the backend is correct
      //navigate to the next screen
    } on DioException catch (e) {
      // Handle DioError
      if (e.response?.statusCode == 404) {
        // Handle 404 error specifically
        print('OTP not found or expired');
      } else {
        // Handle other errors
        print('Request failed with status: ${e.response?.statusCode}');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0, 0.524),
            end: const Offset(0, 0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(70.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      child: MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          backgroundColor: EAqoonsiTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 70, 0, 32),
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
                              ),
                              Container(
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
                                      offset: Offset(
                                        0,
                                        2,
                                      ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Verification Code',
                                          style: EAqoonsiTheme.of(context)
                                              .displaySmall
                                              .override(
                                                fontFamily: 'Outfit',
                                                letterSpacing: 0.0,
                                                color: EAqoonsiTheme.of(context)
                                                    .secondary,
                                              ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 4.0, 0.0, 24.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: null,
                                            child: RichText(
                                              textScaler: MediaQuery.of(context)
                                                  .textScaler,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    //display the phonenumber
                                                    text:
                                                        'Enter the 4 digit code that you received at: ${widget.phoneNumber}',
                                                    style: const TextStyle(),
                                                  ),
                                                ],
                                                style: EAqoonsiTheme.of(context)
                                                    .labelLarge
                                                    .override(
                                                      fontFamily: 'Readex Pro',
                                                      letterSpacing: 0.0,
                                                      lineHeight: 1.5,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        PinCodeTextField(
                                          autoDisposeControllers: false,
                                          appContext: context,
                                          length: 4,
                                          textStyle: EAqoonsiTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                letterSpacing: 0.0,
                                              ),
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          enableActiveFill: true,
                                          autoFocus: true,
                                          enablePinAutofill: true,
                                          errorTextSpace: 16.0,
                                          showCursor: true,
                                          cursorColor:
                                              EAqoonsiTheme.of(context).primary,
                                          obscureText: false,
                                          hintCharacter: '-',
                                          keyboardType: TextInputType.number,
                                          pinTheme: PinTheme(
                                            fieldHeight: 48.0,
                                            fieldWidth: 48.0,
                                            borderWidth: 2.0,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(12.0),
                                              bottomRight:
                                                  Radius.circular(12.0),
                                              topLeft: Radius.circular(12.0),
                                              topRight: Radius.circular(12.0),
                                            ),
                                            shape: PinCodeFieldShape.box,
                                            activeColor: Colors.amber.shade100,
                                            inactiveColor:
                                                Colors.redAccent.shade100,
                                            selectedColor: Colors.pink.shade100,
                                            activeFillColor:
                                                Colors.amber.shade100,
                                            //current selected pin color
                                            selectedFillColor:
                                                EAqoonsiTheme.of(context)
                                                    .secondaryBackground,
                                            //inactive pin color still empty
                                            inactiveFillColor:
                                                EAqoonsiTheme.of(context)
                                                    .primaryBackground,
                                          ),
                                          controller: otpCodeController,
                                          onChanged: (_) {},
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          // validator:
                                          //     .otpCodeControllerValidator
                                          //     .asValidator(context),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 16),
                                            child: EaqoonsiButtonWidget(
                                              onPressed: () async {
                                                //validate the pin code
                                                print(otpCodeController.text);
                                                validateOTP();
                                                //if the pin code is correct
                                                //validate with the backend
                                                //if the backend is correct
                                                //navigate to the next screen
                                                // Navigator.of(context).push(
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         const RegistrationScreen(),
                                                //   ),
                                                // );
                                              },
                                              text: localizations.verifyButton,
                                              options: EaqoonsiButtonOptions(
                                                width: 230,
                                                height: 52,
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 0),
                                                iconPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 0),
                                                color: EAqoonsiTheme.of(context)
                                                    .primaryBackground,
                                                textStyle:
                                                    EAqoonsiTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                elevation: 3,
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              showLoadingIndicator: true,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation']!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}





// async {
//                                               GoRouter.of(context)
//                                                   .prepareAuthEvent();
//                                               final smsCodeVal = _model
//                                                   .otpCodeController!.text;
//                                               if (smsCodeVal == null ||
//                                                   smsCodeVal.isEmpty) {
//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   const SnackBar(
//                                                     content: Text(
//                                                         'Enter SMS verification code.'),
//                                                   ),
//                                                 );
//                                                 return;
//                                               }
//                                               final phoneVerifiedUser =
//                                                   await authManager
//                                                       .verifySmsCode(
//                                                 context: context,
//                                                 smsCode: smsCodeVal,
//                                               );
//                                               if (phoneVerifiedUser == null) {
//                                                 return;
//                                               }

//                                               context.goNamedAuth(
//                                                   'null', context.mounted);
//                                             },