import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class VerifyOTPScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String otpId;
  final String? nationalIDNumberController;

  const VerifyOTPScreen({
    super.key,
    required this.phoneNumber,
    required this.otpId,
    this.nationalIDNumberController,
  });

  @override
  ConsumerState<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends ConsumerState<VerifyOTPScreen>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};
  final otpCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isOtpValid = false;

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

  Future<void> validateOTP() async {
    final localizations = AppLocalizations.of(context)!;

    if (otpCodeController.text.length != 4) {
      _showErrorSnackBar(localizations.invalidOTP);
      return;
    }

    try {
      final dioClient = ref.read(dioProvider);
      final response = await dioClient.post(
        '/otp/validate',
        data: {
          'otpId': widget.otpId,
          'token': otpCodeController.text,
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RegistrationScreen(),
          ),
        );
      } else {
        _showErrorSnackBar("Unexpected error occurred. Please try again.");
      }
    } on BadRequestException catch (e) {
      _showErrorSnackBar(e.message ?? "Invalid OTP. Please try again.");
    } on NotFoundException {
      _showErrorSnackBar("OTP not found or expired");
    } on ApiException catch (e) {
      _showErrorSnackBar(e.message ?? "An error occurred. Please try again.");
    } catch (e) {
      _showErrorSnackBar("An unexpected error occurred. Please try again.");
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      child: Scaffold(
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
                              buildLogo(),
                              _buildVerificationContainer(localizations),
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

  Widget _buildVerificationContainer(AppLocalizations localizations) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Verification Code',
                style: EAqoonsiTheme.of(context).displaySmall.override(
                      fontFamily: 'Outfit',
                      letterSpacing: 0.0,
                      color: EAqoonsiTheme.of(context).secondary,
                    ),
              ),
              _buildInstructions(),
              _buildPinCodeTextField(),
              _buildVerifyButton(localizations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 24.0),
      child: RichText(
        textScaler: MediaQuery.of(context).textScaler,
        text: TextSpan(
          children: [
            TextSpan(
              text:
                  'Enter the 4 digit code that you received at: ${widget.phoneNumber}',
              style: const TextStyle(),
            ),
          ],
          style: EAqoonsiTheme.of(context).labelLarge.override(
                fontFamily: 'Readex Pro',
                letterSpacing: 0.0,
                lineHeight: 1.5,
              ),
        ),
      ),
    );
  }

  Widget _buildPinCodeTextField() {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      controller: otpCodeController,
      keyboardType: TextInputType.number,
      autoFocus: true,
      cursorColor: EAqoonsiTheme.of(context).primary,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        inactiveFillColor: EAqoonsiTheme.of(context).primaryBackground,
        selectedFillColor: EAqoonsiTheme.of(context).secondaryBackground,
        activeColor: EAqoonsiTheme.of(context).primary,
        inactiveColor: EAqoonsiTheme.of(context).secondary,
        selectedColor: EAqoonsiTheme.of(context).primary,
      ),
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      errorAnimationController: null,
      onChanged: (value) {
        setState(() {
          _isOtpValid = value.length == 4;
        });
        print(
            "OTP changed. New value: $value, isOtpValid: $_isOtpValid"); // Debug print
      },
      onCompleted: (_) {
        _formKey.currentState?.validate();
      },
      beforeTextPaste: (text) {
        return true;
      },
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 4) {
          return "Fill in the OTP";
        }
        return null;
      },
    );
  }

  Widget _buildVerifyButton(AppLocalizations localizations) {
    print("Building button. isOtpValid: $_isOtpValid"); // Debug print

    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
        child: EaqoonsiButtonWidget(
          onPressed: _isOtpValid
              ? () {
                  if (_formKey.currentState!.validate()) {
                    validateOTP();
                  }
                }
              : null,
          text: localizations.verifyButton,
          options: EaqoonsiButtonOptions(
            width: 230,
            height: 52,
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            color: _isOtpValid
                ? EAqoonsiTheme.of(context).primaryBackground
                : EAqoonsiTheme.of(context)
                    .accent4
                    .withOpacity(0.5), // Adjusted opacity for disabled state
            textStyle: EAqoonsiTheme.of(context).titleSmall.override(
                  fontFamily: 'Plus Jakarta Sans',
                  color: _isOtpValid
                      ? Colors.white
                      : Colors
                          .grey[300], // Adjusted text color for disabled state
                  fontSize: 16,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
            elevation: _isOtpValid ? 3 : 0,
            borderSide: BorderSide(
              color: _isOtpValid
                  ? Colors.transparent
                  : Colors.grey[300]!, // Added border for disabled state
              width: 1,
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          showLoadingIndicator: true,
        ),
      ),
    );
  }
}
