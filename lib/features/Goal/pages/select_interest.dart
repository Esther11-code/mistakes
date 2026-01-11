import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Goal/pages/Goals/add_goal.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class SelectInterest extends StatelessWidget {
  const SelectInterest({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchGoalCubit = context.watch<GoalCubit>();
    final readGoalCubit = context.read<AuthenticationCubit>();
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    final user = watchAuthCubit.user;
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthInterestsSavedState) {
          user.isMentor
              ? Fluttertoast.showToast(
                  msg: "Skills saved successfully!",
                  gravity: ToastGravity.TOP,
                  backgroundColor: AppColors.success,
                )
              : Fluttertoast.showToast(
                  msg: "Interests saved successfully!",
                  gravity: ToastGravity.TOP,
                  backgroundColor: AppColors.success,
                );
          Navigator.pushNamed(context, Routename.addDetails);
        }
      },
      child: AppScaffold(
        isloading:
            watchGoalCubit.state is GoalLoadingState &&
            watchGoalCubit.category.isEmpty,
        color: AppColors.white,
        body: Column(
          children: [
            AppbarWidget(
              onTap: () => Navigator.pop(context),
              title: user.isMentor ? "Select Skills" : "Select Interests",
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
                        text: user.isMentor
                            ? "Select at least 3 skills you can guide others with."
                            : "Choose at least 3 areas you're interested in. This helps us recommend mentors who can guide you best!",
                      ),

                      SizedBox(height: size.height * 0.01),
                      Column(
                        children: List.generate(
                          watchGoalCubit.category.length,
                          (int index) => InterestsSections(
                            size: size,
                            categoryIndex: index,
                          ),
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
                          InAppText(
                            text: user.isMentor
                                ? "${watchGoalCubit.selectedInterestsCount} skills selected"
                                : "${watchGoalCubit.selectedInterestsCount} interests selected",
                            color: AppColors.blue,
                            fontweight: FontWeight.w600,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      AppButton(
                        isLoading: watchAuthCubit.state is AuthLoadingState,
                        textSize: 20,
                        label: "Continue",
                        buttonColor: AppColors.blue,
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            readGoalCubit.saveUserInterests(
                              watchGoalCubit.selectedInterests,
                            );
                          });
                        },
                      ),
                      SizedBox(height: size.height * 0.015),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
