import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Goal/pages/Goals/add_goal.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/features/Goal/pages/select_interest.dart';
import 'package:mistakes/global%20widgets/export.dart';

class EditInterests extends StatelessWidget {
  const EditInterests({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchGoalCubit = context.watch<GoalCubit>();
    // final readGoalCubit = context.read<GoalCubit>();
    return AppScaffold(
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
                          "Update your interests to get better mentor recommendations",
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
