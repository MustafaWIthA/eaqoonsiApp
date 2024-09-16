import 'package:eaqoonsi/public/login/login_notifier.dart';
import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/submit_widget.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final animationsMap = <String, AnimationInfo>{};
  final TextEditingController nationalIDTextController =
      TextEditingController();
  final FocusNode nationalIDFocusNode = FocusNode();
  final TextEditingController passwordTextController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  String? localErrorMessage;

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
          begin: const Offset(0, 0.524),
          end: const Offset(0, 0),
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 400.ms,
          begin: const Offset(70, 0),
          end: const Offset(0, 0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    ref.listen<AsyncValue<void>>(loginProvider, (_, state) {
      state.whenOrNull(
        data: (_) => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ProfileScreen())),
        error: (error, _) {
          String errorMessage;
          if (error is UnauthorizedException) {
            errorMessage = localizations.invalidLogin;
          } else if (error is NetworkException) {
            errorMessage = localizations.noInternetConnection;
          } else if (error is NotFoundException) {
            errorMessage = localizations.notFounderror;
          } else if (error is ApiException) {
            errorMessage = error.message!;
          } else {
            errorMessage = localizations.unknownError;
          }
          showErrorSnackBar(errorMessage, context);
        },
      );
    });

    final isLoading = ref.watch(loginProvider).isLoading;

    void submitForm() async {
      if (_formKey.currentState!.validate()) {
        await ref.read(authStateProvider.notifier).login(
              nationalIDTextController.text,
              passwordTextController.text,
            );
      }
    }

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
      backgroundColor: EAqoonsiTheme.of(context).primaryBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLogo(),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              localizations.welcomeMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: EAqoonsiTheme.of(context).primaryText,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
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
                            NationalIDInput(
                              controller: nationalIDTextController,
                              focusNode: nationalIDFocusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return localizations.errorMessage;
                                } else if (value.length < 11) {
                                  return localizations.errorMessage;
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 16),
                              child: SizedBox(
                                width: double.infinity,
                                child: EaqoonsiTextFormField(
                                  controller: passwordTextController,
                                  focusNode: passwordFocusNode,
                                  labelText: localizations.passwordLabel,
                                  hintText: localizations.passwordhintText,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return localizations.passwordEmptyError;
                                    } else if (value.length < 6) {
                                      return localizations.passwordLengthError;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            //add forget password on the left side
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5.0, top: 3.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword(),
                                        ),
                                      );
                                    },
                                    child: AutoSizeText(
                                      "Forget Password",
                                      style: TextStyle(
                                        color: EAqoonsiTheme.of(context)
                                            .primaryText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 16),
                                child: SubmitButtonWidget(
                                    onPressed: isLoading
                                        ? null
                                        : () => ref
                                            .read(loginProvider.notifier)
                                            .login(
                                              nationalIDTextController.text,
                                              passwordTextController.text,
                                            ),
                                    buttonText: localizations.loginButton),
                              ),
                            ),
                            RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: localizations.donthaveanaccount,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ).animateOnPageLoad(
                  animationsMap['containerOnPageLoadAnimation']!),
            ],
          ),
        ),
      ),
    );
  }
}
