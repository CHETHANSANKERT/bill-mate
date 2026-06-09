import 'package:bill_mate/components/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/asset_constants.dart';
import '../../routes/app_pages.dart';
import '../button/app_back_button.dart';
import 'text_style.dart';

class StringMap {
  static const String notification = 'notification';
  static const String profile = 'profile';
  static const String setting = 'setting';
}

AppBar commonAppBar({
  String? title,
  Widget? titleWidget,
  VoidCallback? onBackTap,
  required BuildContext context,
  bool isBackReq = true,
  List<Widget>? actionsDefined,
}) {
  return AppBar(
    title: titleWidget ?? appBarTxtBlk(title),
    centerTitle: true,
    leading: isBackReq
        ? appBackButton(context, onPress: () {
            if (onBackTap != null) {
              onBackTap();
            } else {
              Navigator.of(context).pop();
            }
          })
        : const SizedBox.shrink(),
    actions: actionsDefined ,
    backgroundColor: AppColors.kAppBarBg,
  );
}
