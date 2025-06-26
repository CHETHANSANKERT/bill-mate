import 'package:bill_mate/constants/asset_constants.dart';
import 'package:bill_mate/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/button/primary_button.dart';
import '../../components/ui/app_colors.dart';
import '../../components/ui/text_input_field.dart';
import '../../components/ui/text_style.dart';
import '../../routes/app_pages.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpButtonPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    appSnackbar(
        message: 'Sign Up successful (mock)',
        snackbarState: SnackbarState.success);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign Up successful (mock)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kAppBg,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: SvgPicture.asset(
                    LoginImageAssets.billingSignUp,
                    height: 200.h,
                  ),
                ),
                16.verticalSpace,
                const Text(
                  'Create your account',
                  style: AppTextStyles.kw700Primary20,
                ),
                8.verticalSpace,
                const Text(
                  'Sign up to get started with Bill Mate',
                  style: AppTextStyles.kw400Black14,
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                TextInputField(
                  name: 'email',
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  filled: true,
                  fillColor: Colors.white,
                  borderRadius: 12,
                ),
                16.verticalSpace,
                TextInputField(
                  name: 'password',
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: !_passwordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.kBlack,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  borderRadius: 12,
                ),
                16.verticalSpace,
                TextInputField(
                  name: 'confirm_password',
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  obscureText: !_confirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.kBlack,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  borderRadius: 12,
                ),
                24.verticalSpace,
                PrimaryButton(
                  buttonName: 'Sign Up',
                  onClickfunction: _onSignUpButtonPressed,
                ),
                24.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: AppTextStyles.kw400Black14,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.login);
                      },
                      child: const Text(
                        'Log In',
                        style: AppTextStyles.kw700Primary14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
