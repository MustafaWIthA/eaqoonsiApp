import 'package:dio/dio.dart';
import 'package:eaqoonsi/login/login_screen.dart';
import 'package:eaqoonsi/otp/verify_otp.dart';
import 'package:eaqoonsi/registration/registration_notifier.dart';
import 'package:eaqoonsi/widget/animation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/e_aqoonsi_button_widgets.dart';
import '../widget/text_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//create otpId: 6fde4948-7906-4744-8366-0a6b8ec42c35 for provider to hold the value
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

  Future<void> checkNationalIDNumber() async {
    final localizations = AppLocalizations.of(context)!;

    final idNumber = nationalIDNumberController.text;
    // final url = Uri.parse('http://10.0.2.2:9192/digital/card/search/$idNumber');
    print(idNumber);

    try {
      final dio = Dio();
      final response = await dio.get(
        "http://10.0.2.2:9192/digital/card/search/$idNumber",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print("election system");
      print(response.data['data']['phone']);
      print(response.data);
      print("haghagha hagah");

      if (response.data['statusCode'] == 200) {
        ref.read(otpIdProvider.notifier).state = response.data['otpId'];
        final otpId = response.data['otPid'];
        final phoneNumber = response.data['data']['phone'];
        print(otpId);
        ref.read(registrationNotifierProvider.notifier).setUserName(idNumber);
        print("idnumber $idNumber");

        if (otpId != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  VerifyOTPWidget(otpId: otpId, phoneNumber: phoneNumber),
            ),
          );
        }
      } else if (response.data['statusCode'] == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                localizations.invalidNationalIDNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (response.data['statusCode'] == 404) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                localizations.invalidNationalIDNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      print(response.statusCode);
      if (response.data['statusCode'] == 200) {
        if (response.data['statusCode'] == 200) {
          ref.read(registrationNotifierProvider.notifier).setUserName(idNumber);
          print("idnumber $idNumber");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VerifyOTPWidget(
                  otpId: response.data['otPid'],
                  phoneNumber: response.data['data']['phone']),
            ),
          );
        } else if (response.data['statusCode'] == 404) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text(
                  localizations.notfoundNationalIDNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.data['message'])),
          );
        }
      }
    } catch (e) {
      // Show error message
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          //top container
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
                                          Icons.credit_card_rounded,
                                          color: EAqoonsiTheme.of(context)
                                              .secondary,
                                          size: 44.0,
                                        ),
                                      ),
                                      Text(
                                        localizations.appName,
                                        style: EAqoonsiTheme.of(context)
                                            .displaySmall
                                            .override(
                                              fontFamily: 'Outfit',
                                              letterSpacing: 0.0,
                                              color: EAqoonsiTheme.of(context)
                                                  .primaryText,
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
                                          localizations.verifyNationalIDNumber,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Color(0xFF4B39EF),
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 6, 0, 16),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller:
                                                  nationalIDNumberController,
                                              focusNode:
                                                  nationalIDNumberFocusNode,
                                              textInputAction:
                                                  TextInputAction.send,
                                              obscureText: false,
                                              maxLength: 11,
                                              decoration: InputDecoration(
                                                labelText: localizations
                                                    .verifyNationalIDNumberLabel,
                                                labelStyle: const TextStyle(
                                                  color: Color(0xFF57636C),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                hintText: localizations
                                                    .verifyNationalIDNumberHintText,
                                                hintStyle: const TextStyle(
                                                  color: Color(0xFF57636C),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFF1F4F8),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF4B39EF),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFE0E3E7),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFE0E3E7),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFF1F4F8),
                                              ),
                                              style: EAqoonsiTheme.of(context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily:
                                                        'Plus Jakarta Sans',
                                                    color:
                                                        const Color(0xFF101213),
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return localizations
                                                      .invalidNationalIDNumber;
                                                } else if (value.length < 11) {
                                                  return localizations
                                                      .invalidNationalIDNumber;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 16),
                                            child: EaqoonsiButtonWidget(
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  checkNationalIDNumber();
                                                }
                                              },
                                              text: localizations.checkButton,
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
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 12, 0, 12),
                                            child: RichText(
                                              textScaler: MediaQuery.of(context)
                                                  .textScaler,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: localizations
                                                        .haveanaccount,
                                                    style: const TextStyle(),
                                                  ),
                                                  WidgetSpan(
                                                      child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LoginScreen(),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                        localizations
                                                            .loginButton,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF4B39EF),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  )),
                                                ],
                                                style: const TextStyle(
                                                  color: Color(0xFF57636C),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
