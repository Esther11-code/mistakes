
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';
import '../cubit/dashboard_cubit.dart';

class RecentGoals extends StatelessWidget {
  const RecentGoals({
    super.key,
    required this.size,
    required this.goalTitle,
    required this.status,
    required this.progress,
    required this.recentGoals,
  });

  final Size size;
  final String goalTitle, status;
  final int progress;
  final Map<String, dynamic> recentGoals;

  @override
  Widget build(BuildContext context) {
    final hasFeedback = recentGoals['has_feedback'] ?? false;
    final feedbackText = recentGoals['feedback_text'] ?? '';
    final feedbackRating = recentGoals['feedback_rating'] ?? 0;
    final mentorName = recentGoals['mentor_name'] ?? 'Your Mentor';

    return AppshadowContainer(
      padding: EdgeInsets.all(size.width * 0.04),
      shadowcolour: AppColors.blue.withAlpha(50),
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InAppText(
                  text: goalTitle,
                  fontweight: FontWeight.w700,
                  size: 19,
                  color: AppColors.blue,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.006,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InAppText(
                  text: status,
                  color: AppColors.white,
                  fontweight: FontWeight.w700,
                  size: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.015),
          Container(height: size.height * 0.001, color: AppColors.inactive),
          SizedBox(height: size.height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InAppText(text: "Progress", size: 15, color: AppColors.grey),
              InAppText(
                text: "$progress%",
                fontweight: FontWeight.w800,
                color: AppColors.filledColor,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.012),
          Container(
            height: size.height * 0.015,
            decoration: BoxDecoration(
              color: AppColors.inactive,
              borderRadius: BorderRadius.circular(size.width * 0.03),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: progress / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.filledColor, AppColors.blue],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          if (hasFeedback) ...[
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(
                color: AppColors.filledColor.withAlpha(10),
                borderRadius: BorderRadius.circular(size.width * 0.03),
                border: Border.all(
                  color: AppColors.filledColor.withAlpha(50),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InAppText(
                        text: "Mentor Feedback",
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
                  InAppText(
                    text: feedbackText,
                    size: 17,
                    color: AppColors.lightblack,
                    maxline: 5,
                  ),
                  SizedBox(height: size.height * 0.01),
                  InAppText(
                    text: "— $mentorName",
                    size: 14,
                    color: AppColors.grey,
                    fontweight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ] else ...[
            AppButton(
              onTap: () {
                final readDashboardCubit = context.read<DashboardCubit>();
                readDashboardCubit.setSelectedRecentGoal(
                  recentGoals: recentGoals,
                );
                Navigator.pushNamed(context, Routename.mentorFeedback);
              },
              label: "Add Feedback",
              buttonColor: AppColors.filledColor,
              textSize: 16,
            ),
          ],
        ],
      ),
    );
  }
}

class DashboardOptionCard extends StatelessWidget {
  final Size size;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const DashboardOptionCard({
    super.key,
    required this.size,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.29,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(size.width * 0.04),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withAlpha(20),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, color.withAlpha(70)]),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.white, size: 28.sp),
            ),
            SizedBox(height: size.height * 0.01),
            InAppText(
              text: label,

              fontweight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
