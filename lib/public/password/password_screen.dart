import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/submit_widget.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword>
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

  Future<void> resetPassword(String nationalIDNumber) async {
    final localizations = AppLocalizations.of(context)!;
    final idNumber = nationalIDNumberController.text;

    try {
      final dio = Dio(BaseOptions(
        validateStatus: (status) => status! < 500,
      ));

      final response = await dio.post(
        kForgotPasswordUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-API-Key': '898989',
          },
        ),
        data: {
          'nationalID': idNumber,
        },
      );
      print(response.data);

      _handleApiResponse(response.data, localizations);
    } catch (e) {
      showErrorSnackBar('An error occurred: $e', context);
    }
  }

  void _handleApiResponse(
      Map<String, dynamic> data, AppLocalizations localizations) {
    switch (data['statusCodeValue']) {
      case 200:
        showSuccessSnackBar(
            "A password reset link has been sent to your email", context);
        break;
      case 400:
      case 404:
        print(data['message']);
        showErrorSnackBar(localizations.invalidNationalIDNumber, context);
        break;
      default:
        showErrorSnackBar(
            'Unexpected response: ${data['statusCodeValue']}', context);
    }
  }

  void _handleSuccessResponse() {
    showSuccessSnackBar(
        "A password reset link has been sent to your email", context);
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
                buildLogo(),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
              AutoSizeText(
                "Enter your National ID to reset your password",
                textAlign: TextAlign.center,
                maxFontSize: 20,
                minFontSize: 16,
                maxLines: 2,
                style: TextStyle(
                  color: EAqoonsiTheme.of(context).primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              NationalIDInput(
                controller: nationalIDNumberController,
                focusNode: nationalIDNumberFocusNode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.errorMessage;
                  } else if (value.length < 11) {
                    return localizations.errorMessage;
                  }
                  return null;
                },
              ),
              _buildSubmitButton(localizations),
              _buildLoginLink(localizations),
            ],
          ),
        ),
      ),
    );
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      await resetPassword(
        nationalIDNumberController.text,
      );
    }
  }

  Widget _buildSubmitButton(AppLocalizations localizations) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: SubmitButtonWidget(
              onPressed: submitForm, buttonText: "Reset Password")),
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
