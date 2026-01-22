
import 'package:flutter/material.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    super.key,
    required this.size,
    required this.width,
  });

  final Size size;
  final double width;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      padding: EdgeInsets.zero,
      alignment: Alignment.centerLeft,
      height: size.height * 0.015,
      width: size.width,
      borderRadius: BorderRadius.circular(size.height * 0.02),
      color: AppColors.grey.withAlpha(40),
      child: SizedBox(
        width: width,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.filledColor,
            borderRadius: BorderRadius.circular(size.height * 0.02),
          ),
        ),
      ),
    );
  }
}

class StatusContainer extends StatelessWidget {
  const StatusContainer({super.key, required this.size, required this.status});

  final Size size;
  final String status;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.008,
      ),
      borderRadius: BorderRadius.circular(size.width * 0.07),
      border: true,
      borderColor: AppColors.filledColor,
      color: AppColors.inactive,
      child: InAppText(
        text: status,
        color: AppColors.background,
        fontweight: FontWeight.w700,
        size: 14,
      ),
    );
  }
}
