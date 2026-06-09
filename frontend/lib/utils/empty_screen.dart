import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/ui/text_style.dart';
import '../constants/asset_constants.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    required this.titleText,
    this.subTitleText,
    super.key,
  });

  final String titleText;
  final String? subTitleText;
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              GeneralImageAssets.emptyScreen,
            ),
            24.verticalSpace,
            Text(
              titleText,
              style: AppTextStyles.kw900Black32,
            ),
            16.verticalSpace,
            Text(
              subTitleText ?? '',
              style: AppTextStyles.kw600Black16,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
}
