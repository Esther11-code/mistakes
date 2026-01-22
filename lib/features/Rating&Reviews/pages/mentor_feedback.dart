import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Dashboard/pages/cubit/dashboard_cubit.dart';
import 'package:mistakes/features/Rating&Reviews/pages/cubit/review_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import 'widgets/mentor_feedback_widgets.dart';

class MentorReview extends StatefulWidget {
  const MentorReview({super.key});

  @override
  State<MentorReview> createState() => _MentorReviewState();
}

class _MentorReviewState extends State<MentorReview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardCubit>().loadFeedbackForSelectedGoal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchReviewCubit = context.watch<ReviewCubit>();
    final watchDashboardCubit = context.watch<DashboardCubit>();
    final hasFeedback =
        watchDashboardCubit.selectedRecentGoals['has_feedback'] ?? false;
    final feedbackText =
        watchDashboardCubit.selectedRecentGoals['feedback_text'] ?? '';
    final feedbackRating =
        watchDashboardCubit.selectedRecentGoals['feedback_rating'] ?? 0;

    return BlocListener<ReviewCubit, ReviewState>(
      listener: (context, state) {
        if (state is ReviewFeedbackAddedState) {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: AppColors.white,
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
                        Navigator.pushNamed(context, Routename.shareResources);
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
              title: 'Goal Feedback',
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
                        padding: EdgeInsets.all(size.width * 0.04),
                        shadowcolour: AppColors.lightgrey.withAlpha(100),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InAppText(
                                        text:
                                            watchDashboardCubit
                                                .selectedRecentGoals['title'] ??
                                            "Master Flutter",
                                        fontweight: FontWeight.w800,
                                        size: 20,
                                        maxline: 2,
                                      ),
                                      SizedBox(height: size.height * 0.005),
                                      InAppText(
                                        text:
                                            "Due: ${watchDashboardCubit.selectedRecentGoals['deadline'] ?? 'No deadline'}",
                                        size: 16,
                                        color: AppColors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                StatusContainer(
                                  size: size,
                                  status:
                                      watchDashboardCubit
                                          .selectedRecentGoals['status'] ??
                                      "Active",
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InAppText(text: "Progress"),
                                InAppText(
                                  text:
                                      "${watchDashboardCubit.selectedRecentGoals['progress_percentage'] ?? 0}%",
                                  fontweight: FontWeight.w800,
                                  color: AppColors.filledColor,
                                  size: 20,
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.012),
                            AppProgressIndicator(
                              size: size,
                              width:
                                  size.width *
                                  ((watchDashboardCubit
                                              .selectedRecentGoals['progress_percentage'] ??
                                          0) /
                                      100),
                            ),

                            SizedBox(height: size.height * 0.02),
                            if (hasFeedback) ...[
                              Container(
                                width: size.width,
                                padding: EdgeInsets.all(size.width * 0.04),
                                decoration: BoxDecoration(
                                  color: AppColors.filledColor.withAlpha(10),
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.03,
                                  ),
                                  border: Border.all(
                                    color: AppColors.filledColor.withAlpha(50),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InAppText(
                                          text: "Your Feedback",
                                          fontweight: FontWeight.w700,
                                          size: 20,
                                          color: AppColors.blue,
                                        ),
                                        // Star rating display
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) => Icon(
                                              index < feedbackRating
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.orange.shade400,
                                              size: 20.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: size.height * 0.009),
                                    InAppText(
                                      text: feedbackText,

                                      color: AppColors.lightblack,
                                      maxline: 10,
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                  ],
                                ),
                              ),
                            ] else ...[
                              // Show input form
                              if (watchReviewCubit.state
                                  is ReviewFeedbackLoading)
                                Center(
                                  child:
                                      LoadingAnimationWidget.threeArchedCircle(
                                        size: 50,
                                        color: AppColors.filledColor,
                                      ),
                                )
                              else ...[
                                SizedBox(height: size.height * 0.015),
                                ApptextField(
                                  controller:
                                      watchReviewCubit.feedbackController,
                                  hintText: "Write your feedback here...",
                                  maxLine: 5,
                                ),
                                SizedBox(height: size.height * 0.02),
                                InAppText(
                                  text: "Rate Progress",
                                  fontweight: FontWeight.w600,
                                  size: 16,
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    5,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        context.read<ReviewCubit>().showColor(
                                          index: index + 1,
                                        );
                                      },
                                      child: Icon(
                                        index <
                                                watchReviewCubit
                                                    .selectedStarIndex
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.orange.shade400,
                                        size: 40.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.025),
                                AppButton(
                                  isLoading:
                                      watchReviewCubit.state
                                          is ReviewFeedbackLoading,
                                  onTap: () async {
                                    final readDashboardCubit = context
                                        .read<DashboardCubit>();
                                    await context
                                        .read<ReviewCubit>()
                                        .submitGoalFeedback(
                                          goalId: watchDashboardCubit
                                              .selectedRecentGoals['id'],
                                          userId:
                                              context
                                                  .read<AuthenticationCubit>()
                                                  .user
                                                  .id ??
                                              "",
                                        );
                                    await readDashboardCubit
                                        .loadFeedbackForSelectedGoal();
                                  },
                                  label: "Submit Feedback",
                                  buttonColor: AppColors.filledColor,
                                  textSize: 18,
                                ),
                              ],
                            ],
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
