import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Goal/pages/Goals/add_goal.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class SelectInterest extends StatelessWidget {
  const SelectInterest({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchGoalCubit = context.watch<GoalCubit>();
    // final readGoalCubit = context.read<GoalCubit>();
    return AppScaffold(
      color: AppColors.white,
      body: Column(
        children: [
          AppbarWidget(
            onTap: () => Navigator.pop(context),
            title: "Select Interests",
            size: size,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    InfoBar(
                      size: size,
                      icon: Icons.info_outline,
                      text:
                          "Choose at least 3 areas you're interested in. This helps us recommend mentors who can guide you best!",
                    ),

                    SizedBox(height: size.height * 0.01),
                    Column(
                      children: List.generate(
                        watchGoalCubit.category.length,
                        (int index) =>
                            InterestsSections(size: size, categoryIndex: index),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_sharp,
                          color: AppColors.success,
                          size: 26.sp,
                          fontWeight: FontWeight.w800,
                        ),
                        SizedBox(width: size.width * 0.02),
                        AppText(
                          text:
                              "${watchGoalCubit.selectedInterestsCount} interests selected",
                          color: AppColors.blue,
                          fontweight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.03),
                    AppButton(
                      textSize: 20,
                      label: "Continue",
                      buttonColor: AppColors.blue,
                      onTap: () {
                        // Handle continue action
                        Navigator.pushNamed(context, Routename.bottomNav);
                      },
                    ),
                    SizedBox(height: size.height * 0.015),
                    AppButton(
                      textSize: 20,
                      label: "Skip",
                      border: true,
                      buttonColor: AppColors.inactive,
                      bordercolor: AppColors.background,
                      labelColor: AppColors.blue,
                      onTap: () {
                        Navigator.pushNamed(context, Routename.bottomNav);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InterestsSections extends StatelessWidget {
  const InterestsSections({
    super.key,
    required this.size,
    required this.categoryIndex,
  });

  final Size size;
  final int categoryIndex;

  @override
  Widget build(BuildContext context) {
    final watchGoalCubit = context.watch<GoalCubit>();
    final readGoalCubit = context.read<GoalCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        categoryIndex != 0
            ? SizedBox(height: size.height * 0.03)
            : SizedBox.shrink(),
        AppText(
          text: watchGoalCubit.category[categoryIndex],
          color: AppColors.blue,
          fontweight: FontWeight.w700,
          size: 24,
        ),
        SizedBox(height: size.height * 0.0115),
        Wrap(
          spacing: size.width * 0.03,
          runSpacing: size.height * 0.02,
          children: List.generate(
            watchGoalCubit.interests.length,
            (index) => IntrinsicWidth(
              // Add this
              child: GestureDetector(
                onDoubleTap: () {
                  readGoalCubit.removeInterest(watchGoalCubit.interests[index]);
                },
                child: AppshadowContainer(
                  onTap: () {
                    readGoalCubit.addInterest(watchGoalCubit.interests[index]);
                  },
                  radius: size.height * 0.05,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.01,
                  ),
                  border:
                      watchGoalCubit.isInterestSelected(
                        watchGoalCubit.interests[index],
                      )
                      ? false
                      : true,
                  borderColor: AppColors.background,
                  color:
                      watchGoalCubit.isInterestSelected(
                        watchGoalCubit.interests[index],
                      )
                      ? AppColors.blue
                      : AppColors.inactive.withAlpha(100),
                  child: AppText(
                    text: watchGoalCubit.interests[index],
                    color:
                        watchGoalCubit.isInterestSelected(
                          watchGoalCubit.interests[index],
                        )
                        ? AppColors.white
                        : AppColors.blue,
                    fontweight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
