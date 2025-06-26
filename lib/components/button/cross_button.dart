
import 'package:bill_mate/constants/asset_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// cross button
InkWell crossButton(
   BuildContext context,{
  VoidCallback? onTap,
}) =>
    InkWell(
      onTap: onTap ?? () => Navigator.of(context).pop,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: SvgPicture.asset(GeneralImageAssets.icClose,),
      ),
    );
