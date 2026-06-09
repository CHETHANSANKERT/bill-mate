import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/widget_spacing.dart';
import '../ui/app_colors.dart';
import '../ui/text_style.dart';

class TertiaryButton extends StatelessWidget {
  const TertiaryButton({
    super.key,
    required this.buttonName,
    required this.onClickfunction,
    this.isMargin = true,
    this.suffixIcon,
    this.txtStyle,
  });

  final String buttonName;
  final bool isMargin;
  final Widget? suffixIcon;
  final TextStyle? txtStyle;
  final VoidCallback onClickfunction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClickfunction,
      child: Container(
        height: 56.h,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        margin: isMargin ? bottomPadding(context) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: AppColors.kTertiaryBg,
          borderRadius: borderRadius16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            suffixIcon ?? const SizedBox.shrink(),
            4.horizontalSpace,
            Text(
              buttonName,
              style: txtStyle ?? AppTextStyles.kw400Black14,
            ),
          ],
        ),
      ),
    );
  }
}
