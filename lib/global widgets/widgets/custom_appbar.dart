import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/widgets/app_container_withshadow.dart';
import 'package:mistakes/global%20widgets/widgets/app_notification_icon.dart';
import 'package:mistakes/global%20widgets/widgets/app_text.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.onTap,
    this.shadowColor,
    this.iconColor1,
    this.iconColor2,
    this.containerColor,
    this.textColor,
  });
  final String title;
  final Function()? onTap;
  final Color? shadowColor, containerColor, iconColor1, iconColor2, textColor;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Row(
        children: [
          AppshadowContainer(
            color: containerColor ?? AppColors.white,
            shadowcolour: shadowColor ?? AppColors.lightgrey,
            padding: EdgeInsets.all(2.w),
            child: GestureDetector(
              onTap: onTap ?? () => Navigator.pop(context),
              child: Icon(
                CupertinoIcons.back,
                size: 25.sp,
                color: iconColor1 ?? AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Center(
              child: AppText(
                text: title,
                fontweight: FontWeight.w600,
                color: textColor ?? AppColors.blackColor,
              ),
            ),
          ),
          NotificationIcon(
            colors: iconColor2 ?? AppColors.blue,
            containerColor: containerColor,
            shadowColor: shadowColor,
          ),
        ],
      ),
    );
  }
}
