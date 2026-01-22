import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/features/Goal/pages/widgets/add_goal_widget.dart';
import 'package:mistakes/global%20widgets/export.dart';

import 'widgets/select_interest_widgets.dart';

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
