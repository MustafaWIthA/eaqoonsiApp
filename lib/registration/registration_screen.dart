import 'package:eaqoonsi/public/camera/capture_image.dart';
import 'package:eaqoonsi/constants.dart';
import 'package:eaqoonsi/public/login/auth_notifier.dart';
import 'package:eaqoonsi/profile/profile_screen.dart';
import 'package:eaqoonsi/registration/registration_notifier.dart';
import 'package:eaqoonsi/widget/animation.dart';
import 'package:eaqoonsi/widget/e_aqoonsi_button_widgets.dart';
import 'package:eaqoonsi/widget/eaqoonsi_text_from_field.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/text_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController pin = TextEditingController();
  final fullNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final pinFocusNode = FocusNode();

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return null; // Allow empty emails
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
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
    final registrationState = ref.watch(registrationNotifierProvider);

    ref.listen<AuthState>(registrationNotifierProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileScreen()),
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

    return GestureDetector(
      child: MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          backgroundColor: EAqoonsiTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 16),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: EaqoonsiTextFormField(
                                                validator: (fullName) {
                                                  if (fullName!.isEmpty) {
                                                    return localizations
                                                        .fullNameValidation;
                                                  } else if (fullName.length <
                                                      8) {
                                                    return localizations
                                                        .fullNameValidation;
                                                  } else if (!fullName
                                                      .contains(' ')) {
                                                    return localizations
                                                        .fullNameValidation;
                                                  }
                                                  return null;
                                                },
                                                controller: fullName,
                                                focusNode: fullNameFocusNode,
                                                labelText:
                                                    localizations.fullNameLabel,
                                                hintText: localizations
                                                    .fullNamehintText,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 16),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: EaqoonsiTextFormField(
                                                validator: validateEmail,
                                                controller: email,
                                                focusNode: emailFocusNode,
                                                labelText:
                                                    localizations.emailLabel,
                                                hintText:
                                                    localizations.hintText,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 16),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: EaqoonsiTextFormField(
                                                validator: (password) =>
                                                    password!.length < 5
                                                        ? localizations
                                                            .passwordLengthError
                                                        : null,
                                                controller: password,
                                                focusNode: passwordFocusNode,
                                                labelText:
                                                    localizations.passwordLabel,
                                                hintText: localizations
                                                    .passwordhintText,
                                                obscureText: true,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0, 0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 16),
                                              child: EaqoonsiButtonWidget(
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CameraScreen(
                                                                fullName:
                                                                    fullName
                                                                        .text,
                                                                email:
                                                                    email.text,
                                                                password:
                                                                    password
                                                                        .text,
                                                              )),
                                                    );
                                                  }
                                                },
                                                text: localizations
                                                    .registerButton,
                                                options: EaqoonsiButtonOptions(
                                                  width: 230,
                                                  height: 52,
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
                                                  iconPadding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
                                                  color:
                                                      EAqoonsiTheme.of(context)
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
      ),
    );
  }
}
