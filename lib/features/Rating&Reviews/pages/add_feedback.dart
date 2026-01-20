import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Dashboard/pages/cubit/dashboard_cubit.dart';
import 'package:mistakes/features/Goal/pages/Goals/add_goal.dart';
import 'package:mistakes/features/Rating&Reviews/pages/cubit/review_cubit.dart';
import 'package:mistakes/features/Rating&Reviews/pages/mentor_feedback.dart';
import 'package:mistakes/global%20widgets/export.dart';
import '../../../constants/utils/app_colors.dart';

class AddFeedback extends StatefulWidget {
  const AddFeedback({super.key});

  @override
  State<AddFeedback> createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
  @override
  void initState() {
    super.initState();
    // Load feedback when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardCubit>().loadFeedbackForSelectedGoal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchReviewCubit = context.watch<ReviewCubit>();
    final watchDashboardCubit = context.watch<DashboardCubit>();

    // Check if feedback exists
    final hasFeedback =
        watchDashboardCubit.selectedRecentGoals['has_feedback'] ?? false;
    final feedbackText =
        watchDashboardCubit.selectedRecentGoals['feedback_text'] ?? '';
    final feedbackRating =
        watchDashboardCubit.selectedRecentGoals['feedback_rating'] ?? 0;
    final mentorName =
        watchDashboardCubit.selectedRecentGoals['mentor_name'] ?? 'Mentor';

    return BlocListener<ReviewCubit, ReviewState>(
      listener: (context, state) {
        // if (state is ReviewFeedbackLoadedState) {
        //   showAdaptiveDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         backgroundColor: Colors.white,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(12.r),
        //         ),
        //         contentPadding: EdgeInsets.all(size.width * 0.04),
        //         content: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Icon(
        //               Icons.check_circle_outline,
        //               size: 60.sp,
        //               color: AppColors.filledColor,
        //             ),
        //             SizedBox(height: size.height * 0.02),
        //             InAppText(
        //               text: 'Feedback Submitted',
        //               fontweight: FontWeight.w600,
        //               size: 20,
        //             ),
        //             SizedBox(height: size.height * 0.01),
        //             InAppText(
        //               text: 'Thank you for your valuable feedback!',
        //               fontweight: FontWeight.w400,
        //               size: 16,
        //               textAlign: TextAlign.center,
        //             ),
        //             SizedBox(height: size.height * 0.03),
        //             AppButton(
        //               onTap: () {
        //                 Navigator.pop(context);
        //                 Navigator.pop(context);
        //               },
        //               width: size.width,
        //               buttonColor: AppColors.filledColor,
        //               label: 'OK',
        //             ),
        //           ],
        //         ),
        //       );
        //     },
        //   );
        // }
      },
      child: AppScaffold(
        body: Column(
          children: [
            AppbarWidget(
              title: 'Feedback Details',
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
                      // Goal Info Card
                      AppshadowContainer(
                        padding: EdgeInsets.all(size.width * 0.04),
                        shadowcolour: AppColors.lightgrey.withAlpha(100),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InAppText(
                                    text:
                                        watchDashboardCubit
                                            .selectedRecentGoals['title'] ??
                                        'Goal',
                                    fontweight: FontWeight.w800,
                                    size: 20,
                                    maxline: 2,
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
                            SizedBox(height: size.height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InAppText(
                                  text:
                                      watchDashboardCubit
                                          .selectedMentee
                                          ?.name ??
                                      "Mentee",
                                  color: AppColors.grey,
                                  fontweight: FontWeight.w500,
                                  size: 17,
                                ),
                                SizedBox(width: size.width * 0.01),
                                Center(
                                  child: Icon(
                                    Icons.circle,
                                    size: 5.sp,
                                    color: AppColors.grey,
                                  ),
                                ),
                                SizedBox(width: size.width * 0.01),
                                InAppText(
                                  text:
                                      "${watchDashboardCubit.selectedRecentGoals['progress_percentage'] ?? 0}% complete",
                                  fontweight: FontWeight.w500,
                                  color: AppColors.grey,
                                  size: 17,
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
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.03),

                      // ⭐ CONDITIONAL RENDERING: Show Feedback or Input Form
                      if (hasFeedback) ...[
                        // Show existing feedback
                        InAppText(
                          text: "Submitted Feedback",
                          size: 20,
                          fontweight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                        SizedBox(height: size.height * 0.015),
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
                                    size: 18,
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
                                        color: AppColors.yellow,
                                        size: 24.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.015),
                              Container(
                                width: size.width,
                                padding: EdgeInsets.all(size.width * 0.03),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.02,
                                  ),
                                ),
                                child: InAppText(
                                  text: feedbackText,
                                  size: 16,
                                  color: AppColors.lightblack,
                                  maxline: 20,
                                ),
                              ),
                              SizedBox(height: size.height * 0.015),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03,
                                  vertical: size.height * 0.008,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.filledColor.withAlpha(20),
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.02,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 16.sp,
                                      color: AppColors.filledColor,
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    InAppText(
                                      text: "Submitted by $mentorName",
                                      size: 14,
                                      color: AppColors.filledColor,
                                      fontweight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        AppButton(
                          onTap: () => Navigator.pop(context),
                          width: size.width,
                          label: 'Back',
                          labelColor: AppColors.blue,
                          buttonColor: AppColors.grey.withAlpha(50),
                        ),
                      ] else ...[
                        // Show input form
                        if (watchReviewCubit.state is ReviewFeedbackLoading)
                          Center(
                            child: LoadingAnimationWidget.threeArchedCircle(
                              size: 50,
                              color: AppColors.filledColor,
                            ),
                          )
                        else ...[
                          RichText(
                            text: TextSpan(
                              text: 'Your feedback',
                              style: GoogleFonts.sansita(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: '*',
                                  style: GoogleFonts.sansita(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          ApptextField(
                            controller: watchReviewCubit.feedbackController,
                            maxLine: 5,
                            hintText: 'Enter your feedback here',
                          ),
                          SizedBox(height: size.height * 0.03),
                          InAppText(
                            text: "Rate Effort",
                            size: 20,
                            fontweight: FontWeight.w500,
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              5,
                              (index) => GestureDetector(
                                onTap: () {
                                  watchReviewCubit.showColor(index: index + 1);
                                },
                                child:
                                    index + 1 <=
                                        watchReviewCubit.selectedStarIndex
                                    ? Icon(
                                        Icons.star,
                                        size: 40.sp,
                                        color: AppColors.yellow,
                                      )
                                    : Icon(
                                        Icons.star_border,
                                        size: 40.sp,
                                        color: AppColors.grey.withAlpha(50),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),
                          InfoBar(
                            size: size,
                            icon: Icons.lightbulb_outline,
                            text:
                                "Be specific and constructive. Highlight wins and suggest clear next steps.",
                          ),
                          SizedBox(height: size.height * 0.03),
                          AppButton(
                            isLoading:
                                watchReviewCubit.state is ReviewFeedbackLoading,
                            onTap: () async {
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

                              // Reload feedback after submission
                              await context
                                  .read<DashboardCubit>()
                                  .loadFeedbackForSelectedGoal();
                            },
                            width: size.width,
                            buttonColor: AppColors.filledColor,
                            label: 'Submit Feedback',
                          ),
                          SizedBox(height: size.height * 0.02),
                          AppButton(
                            onTap: () {
                              showAdaptiveDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    contentPadding: EdgeInsets.all(
                                      size.width * 0.04,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.warning_amber_outlined,
                                          size: 60.sp,
                                          color: AppColors.yellow,
                                        ),
                                        SizedBox(height: size.height * 0.02),
                                        InAppText(
                                          text: 'You\'re about to cancel',
                                          fontweight: FontWeight.w600,
                                          size: 20,
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        InAppText(
                                          text:
                                              'Are you sure you want to cancel?',
                                          fontweight: FontWeight.w400,
                                          size: 16,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: size.height * 0.03),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AppButton(
                                                bordercolor:
                                                    AppColors.errorColor,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                width: size.width,
                                                buttonColor: Colors.transparent,
                                                label: 'Yes, Cancel',
                                                labelColor:
                                                    AppColors.errorColor,
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.02),
                                            Expanded(
                                              child: AppButton(
                                                bordercolor: AppColors.success,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                width: size.width,
                                                labelColor: AppColors.success,
                                                buttonColor: Colors.transparent,
                                                label: 'No, Continue',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            width: size.width,
                            label: 'Cancel',
                            labelColor: AppColors.blackColor,
                            buttonColor: AppColors.grey.withAlpha(50),
                          ),
                        ],
                      ],
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
