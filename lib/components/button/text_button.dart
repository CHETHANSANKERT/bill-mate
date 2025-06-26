import 'package:flutter/material.dart';

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
        child: Text(
          txt,
          style: textStyle,
        ),
      ),
    );
  }
}
