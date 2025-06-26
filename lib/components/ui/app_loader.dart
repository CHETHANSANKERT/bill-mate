import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif/gif.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../constants/asset_constants.dart';
import 'app_colors.dart';
import 'text_style.dart';

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
      child: Gif(
        color: color,
        colorBlendMode: BlendMode.colorBurn,
        width: radius ?? 32,
        height: radius ?? 32,
        image: const AssetImage(GifAssets.loader),
        autostart: Autostart.loop,
      ),
    );
  }
}

class Loader {
  const Loader(this.ctx);
  final BuildContext ctx;

  show() {
    ctx.loaderOverlay.show();
  }

  showWithMsg(
      {required String msg, TextStyle textStyle = AppTextStyles.kw700White14}) {
    ctx.loaderOverlay.show(
      widgetBuilder: (progress) => Container(
        color: AppColors.kSecondary.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLoader(),
            Padding(
              padding: EdgeInsets.all(60.h),
              child: Text(
                msg,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  hide() {
    ctx.loaderOverlay.hide();
  }
}
