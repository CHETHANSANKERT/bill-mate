import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../ui/text_style.dart';

class TxtBtn extends StatelessWidget {
  const TxtBtn(
      {super.key,
      required this.txt,
      required this.onPress,
      this.textStyle = AppTextStyles.kw400Black12,
      this.kAlign = Alignment.centerRight});

  final String txt;
  final TextStyle textStyle;
  final VoidCallback onPress;
  final Alignment kAlign;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: kAlign,
      child: InkWell(
        onTap: onPress,
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Text(
            txt,
            style: textStyle.copyWith(
              decoration: TextDecoration.underline,
              decorationThickness: 2.h
            ),
          ),
        ),
      ),
    );
  }
}
