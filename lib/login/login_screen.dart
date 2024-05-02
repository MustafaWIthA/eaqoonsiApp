import 'package:eaqoonsi/digital/check_registration.dart';
import 'package:eaqoonsi/language/language_widget.dart';
import 'package:eaqoonsi/login/auth_notifier.dart';
import 'package:eaqoonsi/widget/e_aqoonsi_button_widgets.dart';
import 'package:eaqoonsi/widget/eaqoonsi_text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile/profile_screen.dart';
import '../widget/text_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nationalIDTextController =
      TextEditingController();
  final FocusNode nationalIDFocusNode = FocusNode();
  final TextEditingController passwordTextController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      } else if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(next.errorMessage!),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    EAqoonsiTheme.of(context).primaryBackground,
                    EAqoonsiTheme.of(context).primaryBackground,
                  ],
                  stops: const [0, 1],
                  begin: const AlignmentDirectional(0.87, -1),
                  end: const AlignmentDirectional(-0.87, 1),
                ),
              ),
              alignment: const AlignmentDirectional(0, -1),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 32),
                      child: Container(
                        width: 200,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: const AlignmentDirectional(0, 0),
                        child: Text(
                          localizations.appName,
                          style: EAqoonsiTheme.of(context).titleLarge.override(
                                fontFamily: 'Plus Jakarta Sans',
                                color: EAqoonsiTheme.of(context).alternate,
                                fontSize: 32,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxWidth: 570,
                          ),
                          decoration: BoxDecoration(
                            color: EAqoonsiTheme.of(context).alternate,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    localizations.welcomeMessage,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: EAqoonsiTheme.of(context)
                                          .primaryText, //const Color(0xFF101213
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 12, 0, 24),
                                    child: Text(
                                      localizations.welcomelogininstruction,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF57636C),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 16),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: nationalIDTextController,
                                        focusNode: nationalIDFocusNode,
                                        textInputAction: TextInputAction.send,
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
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xFFF1F4F8),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
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
                                          fillColor: const Color(0xFFF1F4F8),
                                        ),
                                        style: EAqoonsiTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              color: const Color(0xFF101213),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return localizations
                                                .usernameEmptyError;
                                          } else if (value.length < 11) {
                                            return localizations
                                                .usernameLengthError;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  //password field
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 16),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: EaqoonsiTextFormField(
                                        labelText: localizations.passwordLabel,
                                        hintText:
                                            localizations.passwordhintText,
                                        focusNode: passwordFocusNode,
                                        controller: passwordTextController,
                                        obscureText: true,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return localizations
                                                .passwordEmptyError;
                                          } else if (value.length < 6) {
                                            return localizations
                                                .passwordLengthError;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  //login button
                                  Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 16),
                                      child: EaqoonsiButtonWidget(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            await ref
                                                .read(
                                                    authStateProvider.notifier)
                                                .login(
                                                  nationalIDTextController.text,
                                                  passwordTextController.text,
                                                );
                                          }
                                        },
                                        text: localizations.loginButton,
                                        options: EaqoonsiButtonOptions(
                                          width: 230,
                                          height: 52,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 0),
                                          color: EAqoonsiTheme.of(context)
                                              .primaryBackground,
                                          textStyle: EAqoonsiTheme.of(context)
                                              .titleSmall
                                              .override(
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
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        showLoadingIndicator: true,
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 12, 0, 12),
                                    child: RichText(
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                localizations.donthaveanaccount,
                                            style: const TextStyle(),
                                          ),
                                          WidgetSpan(
                                              child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CheckNationalIDNumber(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                                localizations.signUpTitle,
                                                style: const TextStyle(
                                                  color: Color(0xFF4B39EF),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const LanguageSelectionButtons()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
