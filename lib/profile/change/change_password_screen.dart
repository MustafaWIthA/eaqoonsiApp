import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/submit_widget.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FocusNode currentPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final dioClient = ref.read(dioProvider);
        await changePassword(
          dioClient,
          _currentPasswordController.text,
          _newPasswordController.text,
          _confirmPasswordController.text,
        );

        showSuccessSnackBar('Password changed successfully', context);

        // Navigator.of(context).pop();
      } catch (e) {
        showErrorSnackBar(e.toString(), context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        backgroundColor: EAqoonsiTheme.of(context).primaryBackground,
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: kWhiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildChangePasswordIcon(),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
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
                        padding: const EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Change Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: EAqoonsiTheme.of(context).primaryText,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 16),
                              child: SizedBox(
                                width: double.infinity,
                                child: EaqoonsiTextFormField(
                                  focusNode: currentPasswordFocusNode,
                                  controller: _currentPasswordController,
                                  labelText: 'Current Password',
                                  hintText: 'Enter your current password',
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your current password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 16),
                              child: SizedBox(
                                width: double.infinity,
                                child: EaqoonsiTextFormField(
                                  focusNode: newPasswordFocusNode,
                                  controller: _newPasswordController,
                                  labelText: 'New Password',
                                  hintText: 'Enter your new password',
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a new password';
                                    } else if (value.length < 6) {
                                      return 'Password must be at least 6 characters long';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 16),
                              child: SizedBox(
                                width: double.infinity,
                                child: EaqoonsiTextFormField(
                                  focusNode: confirmPasswordFocusNode,
                                  controller: _confirmPasswordController,
                                  labelText: 'Confirm New Password',
                                  hintText: 'Confirm your new password',
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your new password';
                                    } else if (value !=
                                        _newPasswordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 16),
                                child: SubmitButtonWidget(
                                  onPressed:
                                      _isLoading ? null : _changePassword,
                                  buttonText: 'Change Password',
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
            ],
          ),
        ),
      ),
    );
  }
}
