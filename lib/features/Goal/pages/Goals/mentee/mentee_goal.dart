import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../../constants/utils/app_colors.dart';
import '../goal_setup.dart';

class MenteeGoal extends StatelessWidget {
  const MenteeGoal({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchGoalCubit = context.watch<GoalCubit>();
    return AppScaffold(
      color: AppColors.background,
      body: Column(
        children: [
          AppbarWidget(
            onTap: () => Navigator.pop(context),
            title: "My Goals",
            size: size,
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            textColor: AppColors.white,
            iconColor: AppColors.white,
          ),

          SizedBox(height: size.height * 0.03),
          AppshadowContainer(
            border: true,
            borderColor: AppColors.inactive.withAlpha(100),
            color: Colors.transparent,
            width: size.width * 0.9,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                watchGoalCubit.goals.length,
                (int index) => AppshadowContainer(
                  color: watchGoalCubit.selectedGoalIndex == index
                      ? AppColors.inactive.withAlpha(30)
                      : Colors.transparent,
                  onTap: () {
                    context.read<GoalCubit>().changeGoal(index);
                  },
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.015,
                    horizontal: size.width * 0.04,
                  ),
                  child: AppText(
                    text: watchGoalCubit.goals[index],
                    color: watchGoalCubit.selectedGoalIndex == index
                        ? AppColors.white
                        : AppColors.inactive,
                    fontweight: FontWeight.w500,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.025),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "All Goals",
                        color: AppColors.blue,
                        size: 18,
                        fontweight: FontWeight.w600,
                      ),
                      AppButton(
                        width: size.width * 0.3,
                        height: size.height * 0.05,
                        buttonColor: AppColors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: AppColors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: size.width * 0.01),
                            AppText(
                              text: "Add Goal",
                              color: AppColors.white,
                              fontweight: FontWeight.w500,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, Routename.addGoal);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          5,
                          (int index) => GoalContainer(size: size),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}