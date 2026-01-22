import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Size size;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.02,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.background, AppColors.filledColor],
                )
              : null,
          color: isSelected ? null : AppColors.grey.withAlpha(20),
          borderRadius: BorderRadius.circular(size.width * 0.06),

          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.grey.withAlpha(50),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: InAppText(
          text: label,
          size: 20,
          fontweight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? AppColors.white : AppColors.grey,
        ),
      ),
    );
  }
}

class InfoBar extends StatelessWidget {
  const InfoBar({super.key, required this.size, this.text, this.icon});

  final Size size;
  final String? text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      color: AppColors.background,
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      child: AppshadowContainer(
        padding: EdgeInsets.all(size.width * 0.02),
        color: AppColors.inactive,
        margin: EdgeInsets.only(left: size.width * 0.025),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.filledColor, size: 23.sp),
            SizedBox(width: size.width * 0.015),
            SizedBox(
              width: size.width * 0.775,
              child: InAppText(
                text:
                    text ??
                    "Set SMART goals: Specific, Measurable, Achievable, Relevant, Time-bound",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
