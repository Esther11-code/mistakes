import 'package:flutter/material.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../constants/utils/app_colors.dart';

class MentorOrMenteeContainer extends StatelessWidget {
  const MentorOrMenteeContainer({
    super.key,
    required this.size,
    this.text,
    this.color,
    this.subText,
    this.iconColor,
    this.icon,
    this.textColor,
    this.borderColor,
    this.onTap,
  });

  final Size size;
  final String? text, subText;
  final Color? color, iconColor, textColor, borderColor;
  final IconData? icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        alignment: Alignment.center,
        width: size.width * 0.4,
        height: size.width * 0.3,
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          border: Border.all(
            width: size.width * 0.003,
            color: borderColor ?? AppColors.active.withAlpha(100),
          ),
          color: color ?? AppColors.bluelight.withAlpha(50),
          borderRadius: BorderRadius.circular(size.width * 0.05),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: iconColor),
            AppText(
              textAlign: TextAlign.center,
              text: text ?? "Mentor",
              fontweight: FontWeight.w800,
              size: 18,
              color: textColor ?? AppColors.blackColor,
            ),
            AppText(
              textAlign: TextAlign.center,
              text: subText ?? "Guide Others",
              fontweight: FontWeight.w600,
              size: 16,
              color: textColor ?? AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
