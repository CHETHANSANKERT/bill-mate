import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

appBackButton(context, {VoidCallback? onPress}) {
  return InkWell(
      onTap: () {
        if (onPress != null) {
          onPress();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: const Icon(Icons.arrow_back_ios),
      ));
}
