import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants/utils/app_colors.dart';
import '../export.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.buttonColor,
    this.child,
    this.label,
    this.radius,
    this.textSize,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.labelColor,
    this.isLoading = false,
    this.bordercolor,
    this.border,
    this.padding,
  });

  final Color? buttonColor, labelColor, bordercolor;
  final Widget? child;
  final String? label;
  final Function()? onTap;
  final double? width, height, radius, textSize;
  final bool isLoading;
  final bool? border;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppshadowContainer(
      padding: padding,
      border: border ?? false,
      borderColor: bordercolor ?? Colors.transparent,
      onTap: onTap,
      shadowcolour: Colors.transparent,
      width: width ?? size.width,
      height: height ?? size.height * 0.055,
      radius: radius ?? size.width * 0.02,
      color: buttonColor ?? AppColors.blackColor,
      borderRadius:
          borderRadius ?? BorderRadius.circular(radius ?? size.width * 0.02),
      child: isLoading
          ? LoadingAnimationWidget.threeRotatingDots(
              color: AppColors.white,
              size: 20.sp,
            )
          : child ??
                AppText(
                  text: label ?? '',
                  color: labelColor ?? AppColors.white,
                  size: textSize ?? 14,
                  fontweight: FontWeight.w600,
                ),
    );
  }
}
