import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';

import '../../constants/utils/app_colors.dart';
import 'app_backbutton.dart';
import 'app_text.dart';

class AppbarWidget extends StatelessWidget {
  const AppbarWidget({
    super.key,
    required this.size,
    required this.title,
    this.onTap,
    this.color,
    this.textColor,
    this.shadowColor,
    this.iconColor,
  });

  final Size size;
  final String title;
  final Function()? onTap;
  final Color? color, textColor, shadowColor, iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppbackButton(
            onTap:
                onTap ??
                () => Navigator.popAndPushNamed(context, Routename.bottomNav),
            color: color,
            shadowColor: shadowColor,
            iconColor: iconColor,
          ),
          50.horizontalSpace,
          Center(
            child: AppText(
              color: textColor ?? AppColors.blackColor,
              text: title,
              fontweight: FontWeight.w600,
              size: 20,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
