import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../components/ui/app_colors.dart';
import '../components/ui/text_style.dart';
import 'app_snackbar.dart';

class OtpFieldBox extends StatelessWidget {
  final TextEditingController otpcontroller;
  final GlobalKey<FormState> formkey;
  final int numberoffield;
  const OtpFieldBox(
      {required this.otpcontroller,
      required this.formkey,
      this.numberoffield = 4,
      super.key});

  @override
  Widget build(BuildContext context) {
    PinTheme buildPinTheme() => PinTheme(
          height: 38.h,
          width: 38.w,
          textStyle: AppTextStyles.kw700Black14,
          decoration: BoxDecoration(
            color: AppColors.kAppBg,
            border: Border.all(color: AppColors.kSecondary),
            borderRadius: BorderRadius.circular(8),
          ),
        );
    PinTheme focusedPinTheme() => PinTheme(
          height: 38.h,
          width: 38.w,
          textStyle: AppTextStyles.kw700Black14,
          decoration: BoxDecoration(
            color: AppColors.kAppBg,
            border: Border.all(color: AppColors.kBlack),
            borderRadius: BorderRadius.circular(8),
          ),
        );
    PinTheme errorPinTheme() => PinTheme(
          height: 38.h,
          width: 38.w,
          textStyle: AppTextStyles.kw700Black14,
          decoration: BoxDecoration(
            color: AppColors.kAppBg,
            border: Border.all(color: AppColors.kError),
            borderRadius: BorderRadius.circular(8),
          ),
        );

    return Form(
      key: formkey,
      child: Pinput(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          pinAnimationType: PinAnimationType.fade,
          defaultPinTheme: buildPinTheme(),
          errorPinTheme: errorPinTheme(),
          focusedPinTheme: focusedPinTheme(),
          followingPinTheme: buildPinTheme(),
          submittedPinTheme: buildPinTheme(),
          disabledPinTheme: buildPinTheme(),
          controller: otpcontroller,
          length: numberoffield,
          onChanged: (val) {
            otpcontroller.text = val;
          },
          validator: (value) {
            if ((value?.isEmpty ?? true) ||
                (otpcontroller.length < numberoffield)) {
              appSnackbar(message: 'Please enter OTP');
              return '';
            } else {
              return null;
            }
          }),
    );
  }
}
