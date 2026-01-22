import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/features/Goal/pages/widgets/add_goal_widget.dart';
import 'package:mistakes/features/Goal/pages/widgets/select_interest_widgets.dart';
import 'package:mistakes/global%20widgets/export.dart';

class EditInterests extends StatelessWidget {
  const EditInterests({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchGoalCubit = context.watch<GoalCubit>();
    final readAuthCubit = context.read<AuthenticationCubit>();
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    final user = watchAuthCubit.user;
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthInterestsSavedState) {
          user.isMentor ?
          Fluttertoast.showToast(
            msg: "Skills saved successfully!",
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.success,
          ):
          Fluttertoast.showToast(
            msg: "Interests saved successfully!",
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.success,
          );
          Navigator.pushNamed(context, Routename.profileSetup);
        }
      },
      child: AppScaffold(
        isloading:
            watchGoalCubit.state is GoalLoadingState &&
            watchGoalCubit.category.isEmpty,
        body: Column(
          children: [
            AppbarWidget(
              onTap: () => Navigator.pop(context),
              title:user.isMentor ? "Edit Skills" : "Edit Interests",
              size: size,
            ),
            SizedBox(height: size.height * 0.02),
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
                        text: user.isMentor ? "Update your skills to know which mentees are best for you" :
                            "Update your interests to get better mentor recommendations",
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
                            text: user.isMentor ?
                                "${watchGoalCubit.selectedInterestsCount} skills selected" :
                                "${watchGoalCubit.selectedInterestsCount} interests selected",
                            color: AppColors.blue,
                            fontweight: FontWeight.w600,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      AppButton(
                        isLoading:
                            context.watch<AuthenticationCubit>().state
                                is AuthLoadingState,
                        textSize: 20,
                        label: "Continue",
                        buttonColor: AppColors.blue,
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            readAuthCubit.saveUserInterests(
                              watchGoalCubit.selectedInterests,
                            );
                          });
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
      ),
    );
  }
}
