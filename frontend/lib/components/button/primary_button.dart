import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/widget_spacing.dart';
import '../ui/app_colors.dart';
import '../ui/text_style.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.buttonName,
    required this.onClickfunction,
    this.kSize,
    this.suffixIcon,
    this.isMargin = true,
  });

  final String buttonName;
  final bool isMargin;
  final Size? kSize;
  final VoidCallback onClickfunction;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onClickfunction();
      },
      child: Container(
        height: kSize?.height ?? 56.h,
        width: kSize?.width,
        alignment: Alignment.center,
        margin: isMargin ? bottomPadding(context) : EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: borderRadius16,
          color: AppColors.kPrimaryBg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            suffixIcon ?? const SizedBox.shrink(),
            suffixIcon != null ? 4.horizontalSpace : const SizedBox.shrink(),
            Text(
              buttonName,
              style: AppTextStyles.kw700Primary16,
            ),
          ],
        ),
      ),
    );
  }
}
