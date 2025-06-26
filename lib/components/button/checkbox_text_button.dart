import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../ui/app_colors.dart';
import '../ui/text_style.dart';

// ignore: must_be_immutable
class CheckBoxTextButton extends StatelessWidget {
  const CheckBoxTextButton({
    super.key,
    required this.checkStatus,
    required this.onCheckChanged,
    this.hyperText = ' Terms of Service and Privacy Policy',
    this.checkText = 'Accept',
  });

  final bool checkStatus;
  final ValueChanged<bool> onCheckChanged; // Callback to handle state change
  final String checkText;
  final String hyperText;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      InkWell(
        onTap: () => onCheckChanged(!checkStatus),
        child: SizedBox(
          width: 20.h,
          height: 20.h,
          child: checkStatus
              ? const Icon(
                  Icons.check_box_outlined,
                  color: AppColors.kSuccess,
                )
              : const Icon(
                  Icons.check_box_outline_blank,
                  color: AppColors.kSecondary,
                ),
        ),
      ),
      16.horizontalSpace,
      Expanded(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: checkText, style: AppTextStyles.kw700Black14),
              TextSpan(text: hyperText, style: AppTextStyles.kHyperLink14),
            ],
          ),
        ),
      ),
    ]);
  }
}
