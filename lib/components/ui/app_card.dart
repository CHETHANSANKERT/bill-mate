import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class BuildCard extends StatelessWidget{
  const BuildCard({
    required this.cardColor,
    required this.childWidget,
    super.key,
  } );
  final Color cardColor;
  final Widget childWidget;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.kOutline),
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.kOutline.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: childWidget,
    );
  }
}