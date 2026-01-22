
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';
import '../cubit/goal_cubit.dart';

class InterestsSections extends StatelessWidget {
  final Size size;
  final int categoryIndex;

  const InterestsSections({
    super.key,
    required this.size,
    required this.categoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    final watchGoalCubit = context.watch<GoalCubit>();
    final readGoalCubit = context.read<GoalCubit>();

    final categoryName = watchGoalCubit.category[categoryIndex];
    final interests = watchGoalCubit.getInterestsForCategory(categoryName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.015,
            horizontal: size.width * 0.02,
          ),
          child: InAppText(
            text: categoryName,
            size: 24,
            fontweight: FontWeight.w700,
            color: AppColors.blue,
          ),
        ),
        Wrap(
          spacing: size.width * 0.02,
          runSpacing: size.height * 0.01,
          children: interests.map((interest) {
            final isSelected = watchGoalCubit.isInterestSelected(interest);

            return GestureDetector(
              onTap: () {
                if (isSelected) {
                  readGoalCubit.removeInterest(interest);
                } else {
                  readGoalCubit.addInterest(interest);
                }
              },
              child: IntrinsicWidth(
                child: AppshadowContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.012,
                  ),
                  borderRadius: BorderRadius.circular(size.width * 0.1),
                  color: isSelected
                      ? AppColors.blue
                      : AppColors.inactive.withAlpha(30),
                  border: true,
                  borderColor: isSelected
                      ? AppColors.blue
                      : AppColors.grey.withAlpha(50),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.white,
                        ),
                      if (isSelected) SizedBox(width: 4),
                      InAppText(
                        text: interest,
                        size: 14,
                        color: isSelected ? AppColors.white : AppColors.blue,
                        fontweight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: size.height * 0.02),
      ],
    );
  }
}
