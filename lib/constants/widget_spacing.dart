// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/ui/app_colors.dart';

EdgeInsets bottomPadding(BuildContext ctx) {
  return EdgeInsets.fromLTRB(
      16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16);
}

Divider commonDivider = const Divider(
  color: AppColors.kOutline,
  thickness: 1,
  height: 1,
);

Border outlineBorderAll = Border.all(color: AppColors.kOutline);

BorderRadius borderRadius16 = BorderRadius.circular(16);
BorderRadius bottomBorderRadius16 =
    const BorderRadius.vertical(bottom: Radius.circular(16));
BorderRadius topBorderRadius16 =
    const BorderRadius.vertical(top: Radius.circular(16));
