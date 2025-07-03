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
  required String title,
  VoidCallback? onBackTap,
  required BuildContext context,
  bool isBackReq = true,
  List<Widget>? actionsDefined,
  List<String> sm = const [],
}) {
  final Map<String, Widget Function(BuildContext)> actionMap = {
    StringMap.notification: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notification);
            },
            child: SvgPicture.asset(GeneralImageAssets.icNotification),
          ),
        ),
    StringMap.profile: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
            child: SvgPicture.asset(GeneralImageAssets.defaultProfile),
          ),
        ),
    StringMap.setting: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.setting);
            },
            child: SvgPicture.asset(GeneralImageAssets.icNotification),
          ),
        ),
  };

  List<Widget> actions = [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
          children: sm.map((action) {
        return actionMap[action]?.call(context) ?? const SizedBox.shrink();
      }).toList()),
    ),
  ];

  return AppBar(
    title: appBarTxtBlk(title),
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
    actions: actionsDefined ?? actions,
    backgroundColor: AppColors.kAppBarBg,
  );
}
