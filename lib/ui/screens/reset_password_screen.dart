import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/screens/forgot_password_otp_screen.dart';
import 'package:task_manager_project/ui/screens/sign_in_screen.dart';
import 'package:task_manager_project/ui/utils/app_colors.dart';
import 'package:task_manager_project/ui/widgets/screen_background.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(this.email, this.otp,{super.key});
  final String email;
  final int otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController TEPassword = TextEditingController();
  TextEditingController TEConfirmPassword = TextEditingController();
  bool _inProgress = false;


  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 82),
                Text(
                  'Set Password',
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Minimum number of password should be 8 letters',
                  style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildResetPasswordForm(),
                const SizedBox(height: 48),
                Center(
                  child: _buildHaveAccountSection(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return Column(
      children: [
        TextFormField(
          controller: TEPassword,
          decoration: const InputDecoration(hintText: 'Password'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: TEConfirmPassword,
          decoration: const InputDecoration(hintText: 'Confirm Password'),
        ),
        const SizedBox(height: 24),
        Visibility(
          visible: !_inProgress,
          replacement: const CenteredCircularProgressIndicator(),
          child: ElevatedButton(
            onPressed: _onTapNextButton,
            child: const Icon(Icons.arrow_circle_right_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildHaveAccountSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.5),
        text: "Have account? ",
        children: [
          TextSpan(
              text: 'Sign In',
              style: const TextStyle(color: AppColors.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignIn),
        ],
      ),
    );
  }

  void _onTapNextButton() {
    String password = TEPassword.text.trim();
    String confirmPassword = TEConfirmPassword.text.trim();
    if(password==confirmPassword)
      {
        _updateProfile(widget.email,widget.otp,password);
      }
    else{
      showSnackBarMessage(context, "Password did not match");
    }
  }

  Future<void> _updateProfile(String email, int otp, String password) async {
    _inProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": email,
      "OTP": otp.toString(),
      "password": password
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.recoverResetPassword,
      body: requestBody,
    );
    _inProgress = false;
    setState(() {});
    if (response.isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
            (_) => false,
      );
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (_) => false,
    );
  }
}
