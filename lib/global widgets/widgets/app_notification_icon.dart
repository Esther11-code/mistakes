import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/widgets/app_container_withshadow.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key, this.colors, this.containerColor, this.shadowColor});

  final Color? colors, containerColor, shadowColor;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppshadowContainer(
      color:containerColor ?? AppColors.white,
      shadowcolour:shadowColor?? AppColors.inactive,
      padding: EdgeInsets.all(size.width * 0.025),
      onTap: () => Navigator.pushNamed(context, Routename.notification),
      child: Icon(
        Icons.notifications,
        size: 25.sp,
        color: colors ?? AppColors.background,
      ),
    );
  }
}
