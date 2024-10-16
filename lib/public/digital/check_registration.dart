import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

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

  Future<void> checkNationalIDNumber() async {
    final localizations = AppLocalizations.of(context)!;
    final idNumber = nationalIDNumberController.text;

    try {
      final dio = Dio(BaseOptions(
        validateStatus: (status) => status! < 500,
      ));
      // print(kDigitalSearchUrl);

      final response = await dio.get(
        "$kDigitalSearchUrl/$idNumber",
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print(response.data);

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
    final otpId = data['otPid'];
    final phoneNumber = data['data']['phone'];
    //masking the phone number show only the last 4 digits
    final maskedPhoneNumber = phoneNumber.replaceRange(0, 6, '******');

    ref
        .read(registrationNotifierProvider.notifier)
        .setUserName(nationalIDNumberController.text);
    if (otpId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              VerifyOTPScreen(otpId: otpId, phoneNumber: maskedPhoneNumber),
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
    return Center(
      child: Container(
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
                  localizations.verifyNationalIDNumber,
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
                    focusNode: nationalIDNumberFocusNode),
                _buildSubmitButton(localizations),
                _buildLoginLink(localizations),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      await checkNationalIDNumber();
    }
  }

  Widget _buildSubmitButton(AppLocalizations localizations) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: SubmitButtonWidget(
              onPressed: submitForm, buttonText: localizations.checkButton)),
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
