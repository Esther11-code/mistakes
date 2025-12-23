import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/widgets/app_container_withshadow.dart';

class AppbackButton extends StatelessWidget {
  const AppbackButton({super.key, this.onTap, this.color, this.shadowColor, this.iconColor});
  final Function()? onTap;
  final Color? color,shadowColor,iconColor;
  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      color:color?? AppColors.white,
      padding: EdgeInsets.all(3.h),
      shadowcolour:shadowColor?? AppColors.inactive,
      onTap: onTap ?? () => Navigator.pop(context),
      child: Icon(
        Icons.chevron_left_outlined,
        size: 30.sp,
        color:iconColor?? AppColors.blue,
      ),
    );
  }
}
