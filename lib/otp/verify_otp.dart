import 'package:eaqoonsi/registration/registration_screen.dart';
import 'package:eaqoonsi/widget/animation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

import '../widget/e_aqoonsi_button_widgets.dart';
import '../widget/text_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyOTPWidget extends StatefulWidget {
  const VerifyOTPWidget({
    super.key,
    this.nationalIDNumberController,
  });

  final String? nationalIDNumberController;

  @override
  State<VerifyOTPWidget> createState() => _VerifyOTPWidgetState();
}

class _VerifyOTPWidgetState extends State<VerifyOTPWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};
  final pinCodeController = TextEditingController();
  //pinCodeControllerValidator

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
                              Container(
                                width: double.infinity,
                                height: 140.0,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16.0),
                                    bottomRight: Radius.circular(16.0),
                                    topLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(0.0),
                                  ),
                                ),
                                alignment:
                                    const AlignmentDirectional(-1.0, 0.0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 12.0, 0.0),
                                        child: Icon(
                                          Icons.sms_outlined,
                                          color: EAqoonsiTheme.of(context)
                                              .secondary,
                                          size: 44.0,
                                        ),
                                      ),
                                      Text(
                                        'eAqoonsi',
                                        style: EAqoonsiTheme.of(context)
                                            .displaySmall
                                            .override(
                                              fontFamily: 'Outfit',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ],
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
                                                children: const [
                                                  TextSpan(
                                                    text:
                                                        'Enter the 6 digit code that you received at: ',
                                                    style: TextStyle(),
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
                                            activeColor:
                                                EAqoonsiTheme.of(context)
                                                    .primaryText,
                                            inactiveColor: Colors.blueAccent,
                                            selectedColor:
                                                EAqoonsiTheme.of(context)
                                                    .primary,
                                            activeFillColor:
                                                EAqoonsiTheme.of(context)
                                                    .primaryBackground,
                                            inactiveFillColor:
                                                EAqoonsiTheme.of(context)
                                                    .secondaryBackground,
                                            selectedFillColor:
                                                EAqoonsiTheme.of(context)
                                                    .primary,
                                          ),
                                          controller: pinCodeController,
                                          onChanged: (_) {},
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          // validator:
                                          //     .pinCodeControllerValidator
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
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RegistrationScreen(),
                                                  ),
                                                );
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
//                                                   .pinCodeController!.text;
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