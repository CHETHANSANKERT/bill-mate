import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/widget_spacing.dart';
import '../ui/app_colors.dart';
import '../ui/text_style.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.buttonName,
    required this.onClickfunction,
    this.isMargin = true,
    this.suffixIcon,
    this.txtStyle = AppTextStyles.kw700Secondary18,
  });

  final String buttonName;
  final VoidCallback onClickfunction;
  final bool isMargin;
  final TextStyle? txtStyle;
  final SvgPicture? suffixIcon;

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
          borderRadius: borderRadius16,
          color: AppColors.kSecondaryBg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            suffixIcon ?? const SizedBox.shrink(),
            4.horizontalSpace,
            Text(
              buttonName,
              style: txtStyle,
            ),
          ],
        ),
      ),
    );
  }
}
