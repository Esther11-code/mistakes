
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/widgets/app_text.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final Size size;

  const StatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.blue),
        SizedBox(width: 4),
        InAppText(
          text: value,
          size: 15,
          fontweight: FontWeight.w600,
          color: AppColors.blue,
        ),
      ],
    );
  }
}

class GoalChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Size size;

  const GoalChip({
    super.key,
    required this.label,
    required this.icon,
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
          vertical: size.height * 0.012,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [AppColors.blue, AppColors.filledColor])
              : null,
          color: isSelected ? null : AppColors.grey.withAlpha(10),
          borderRadius: BorderRadius.circular(size.width * 0.05),
          border: Border.all(
            color: isSelected ? AppColors.white : AppColors.grey.withAlpha(50),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.blue.withAlpha(50),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isSelected ? AppColors.white : AppColors.grey,
            ),
            SizedBox(width: 6),
            InAppText(
              text: label,
              size: 16,
              fontweight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.white : AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({
    super.key,
    required this.size,
    this.width,
    this.height,
    this.color,
  });

  final Size size;
  final double? width, height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? size.width * 0.004,
      height: height ?? size.height * 0.05,
      color: color ?? AppColors.white.withAlpha(70),
    );
  }
}
