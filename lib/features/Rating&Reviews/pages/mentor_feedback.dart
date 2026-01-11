import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/features/Rating&Reviews/pages/cubit/review_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class MentorReview extends StatelessWidget {
  const MentorReview({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchReviewCubit = context.watch<ReviewCubit>();
    final watchGoalCubit = context.watch<GoalCubit>();
    return BlocListener<ReviewCubit, ReviewState>(
      listener: (context, state) {
        if (state is ReviewFeedbackLoadedState) {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                contentPadding: EdgeInsets.all(size.width * 0.04),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 60.sp,
                      color: AppColors.filledColor,
                    ),
                    SizedBox(height: size.height * 0.02),
                    InAppText(
                      text: 'Feedback Submitted',
                      fontweight: FontWeight.w600,
                      size: 20,
                    ),
                    SizedBox(height: size.height * 0.01),
                    InAppText(
                      text: 'Thank you for your valuable feedback!',
                      fontweight: FontWeight.w400,
                      size: 16,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.03),
                    AppButton(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      width: size.width,
                      buttonColor: AppColors.filledColor,
                      label: 'OK',
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
      child: AppScaffold(
        body: Column(
          children: [
            AppbarWidget(
              title: 'Selected Mentee Goals',
              size: size,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: size.height * 0.02),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppshadowContainer(
                        border: true,
                        borderColor: AppColors.filledColor,
                        color: Colors.transparent,
                        width: size.width * 0.9,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            watchGoalCubit.goalFilterOptions.length,
                            (int index) => AppshadowContainer(
                              color: watchGoalCubit.selectedGoalIndex == index
                                  ? AppColors.filledColor
                                  : Colors.transparent,
                              onTap: () {
                                context.read<GoalCubit>().changeGoalFilter(
                                  index,
                                );
                              },
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015,
                                horizontal: size.width * 0.04,
                              ),
                              child: InAppText(
                                text: watchGoalCubit.goalFilterOptions[index],
                                color: watchGoalCubit.selectedGoalIndex == index
                                    ? AppColors.white
                                    : AppColors.grey,
                                fontweight: FontWeight.w500,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      AppshadowContainer(
                        padding: EdgeInsets.all(size.width * 0.04),
                        shadowcolour: AppColors.lightgrey.withAlpha(100),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    InAppText(
                                      text: "Master Flutter",
                                      fontweight: FontWeight.w800,
                                      size: 20,
                                    ),
                                    InAppText(
                                      text: "Due: Dec 31, 2024",
                                      size: 16,
                                      color: AppColors.grey,
                                    ),
                                  ],
                                ),
                                StatusContainer(size: size, status: "Active"),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InAppText(text: "Progress"),
                                InAppText(
                                  text: " 70%",
                                  fontweight: FontWeight.w800,
                                  color: AppColors.filledColor,
                                  size: 20,
                                ),
                              ],
                            ),

                            SizedBox(height: size.height * 0.012),
                            AppProgressIndicator(
                              size: size,
                              width: size.width * 0.7,
                            ),
                            SizedBox(height: size.height * 0.02),
                            if (watchReviewCubit.state is ReviewFeedbackLoading)
                              LoadingAnimationWidget.threeArchedCircle(
                                size: 50,
                                color: AppColors.filledColor,
                              )
                            else
                              Visibility(
                                visible: !watchReviewCubit.displayFeedbackField,
                                child: ApptextField(
                                  controller:
                                      watchReviewCubit.feedbackController,
                                  hintText: "Write your feedback here...",
                                  maxLine: 4,
                                ),
                              ),
                            Visibility(
                              visible: watchReviewCubit.displayFeedbackField,
                              child: AppshadowContainer(
                                color: AppColors.background,

                                child: AppshadowContainer(
                                  padding: EdgeInsets.all(size.width * 0.02),
                                  color: AppColors.active,
                                  margin: EdgeInsets.only(
                                    left: size.width * 0.025,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InAppText(
                                            text: "Goal Set",
                                            fontweight: FontWeight.w700,
                                            size: 20,
                                          ),

                                          InAppText(
                                            text: "Today",
                                            color: AppColors.blue.withAlpha(
                                              100,
                                            ),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: size.width * 0.775,
                                        child: InAppText(
                                          text:
                                              "Set SMART goals: Specific, Measurable, Achievable, Relevant, Time-bound",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    onTap: () {
                                      context
                                          .read<ReviewCubit>()
                                          .submitFeedback();
                                    },
                                    label: "Submit Feedback",
                                    buttonColor: AppColors.filledColor,
                                    textSize: 18,
                                  ),
                                ),
                                SizedBox(width: size.width * 0.04),
                                Expanded(
                                  child: AppButton(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routename.addFeedback,
                                      );
                                    },
                                    label: "View Details",
                                    buttonColor: AppColors.grey.withAlpha(40),
                                    bordercolor: AppColors.grey.withAlpha(80),
                                    labelColor: AppColors.blackColor,
                                    textSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
        // vertical: size.height * 0.009,
      ),
      borderRadius: BorderRadius.circular(size.width * 0.07),
      border: true,
      borderColor: AppColors.filledColor,
      color: AppColors.inactive,
      child: InAppText(
        text: "Active",
        color: AppColors.background,
        fontweight: FontWeight.w700,
      ),
    );
  }
}
