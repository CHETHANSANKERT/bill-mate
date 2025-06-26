import 'package:bill_mate/components/button/tertiary_button.dart';
import 'package:bill_mate/constants/asset_constants.dart';
import 'package:bill_mate/routes/app_pages.dart';
import 'package:bill_mate/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../bloc/login/login_bloc.dart';
import '../../components/button/primary_button.dart';
import '../../components/ui/app_colors.dart';
import '../../components/ui/text_input_field.dart';
import '../../components/ui/text_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginButtonPressed() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isNotEmpty && password.isNotEmpty) {
      context
          .read<LoginBloc>()
          .add(LoginRequested(username: username, password: password));
    } else {
      appSnackbar(message: 'Please enter username and password');
    }
  }

  Widget _buildOrSeparator() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: const Text(
            'Or',
            style: AppTextStyles.kw400Black14,
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kAppBg,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccess) {
            // Navigate to BillingHomeScreen on successful login
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed: ${state.error}')),
            );
          }
        },
        child: SingleChildScrollView(
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
                  Image.asset(
                    GeneralImageAssets.billingSplashImage,
                    height: 200.h,
                  ),
                  const Text(
                    'It was popularised in the 1960s with the release of\nLetraset sheetscontaining Lorem Ipsum.',
                    style: AppTextStyles.kw400Black12,
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                  SizedBox(
                    width: 0.5.sw,
                    child: TertiaryButton(
                      buttonName: 'Google',
                      onClickfunction: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      },
                      suffixIcon: SvgPicture.asset(
                        LoginImageAssets.icGoogle,
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  _buildOrSeparator(),
                  24.verticalSpace,
                  TextInputField(
                    name: 'username',
                    controller: _usernameController,
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
                  8.verticalSpace,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forget Password?',
                        style: AppTextStyles.kw400Primary12,
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  PrimaryButton(
                    buttonName: 'Log In',
                    onClickfunction: _onLoginButtonPressed,
                  ),
                  16.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have account? ",
                        style: AppTextStyles.kw400Black14,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.signup);
                        },
                        child: const Text(
                          'Sign Up',
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
      ),
    );
  }
}
