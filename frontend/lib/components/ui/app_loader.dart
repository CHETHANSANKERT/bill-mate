import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/asset_constants.dart';
import 'app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.color = AppColors.kSecondaryBg,
    this.radius,
  });

  final Color color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: radius ?? 60.w,
        height: radius ?? 60.w,
        child: DotLottieLoader.fromAsset(
          AnimationAssets.loader,
          frameBuilder: (context, dotlottie) {
            return const SizedBox.shrink();
          },
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}