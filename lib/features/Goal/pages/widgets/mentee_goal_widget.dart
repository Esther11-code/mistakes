import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';
import '../../../Authentication/presentation/cubit/authentication_cubit.dart';

class GoalFilterTabs extends StatelessWidget {
  final Size size;

  const GoalFilterTabs({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final readGoalCubit = context.read<GoalCubit>();
    final watchGoalCubit = context.watch<GoalCubit>();

    return AppshadowContainer(
      border: true,
      borderColor: AppColors.inactive.withAlpha(100),
      color: Colors.transparent,
      width: size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          watchGoalCubit.goalFilterOptions.length,
          (int index) => AppshadowContainer(
            color: watchGoalCubit.selectedGoalFilterIndex == index
                ? AppColors.inactive.withAlpha(30)
                : Colors.transparent,
            onTap: () => readGoalCubit.changeGoalFilter(index),
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.015,
              horizontal: size.width * 0.04,
            ),
            child: InAppText(
              text: watchGoalCubit.goalFilterOptions[index],
              color: watchGoalCubit.selectedGoalFilterIndex == index
                  ? AppColors.white
                  : AppColors.inactive,
              fontweight: FontWeight.w500,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyGoalsView extends StatelessWidget {
  final Size size;
  final String filterType;

  const EmptyGoalsView({
    super.key,
    required this.size,
    required this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.track_changes,
            size: 80.sp,
            color: AppColors.grey.withAlpha(100),
          ),
          SizedBox(height: size.height * 0.02),
          InAppText(
            text: "No $filterType Goals",
            size: 20,
            fontweight: FontWeight.bold,
            color: AppColors.blue,
          ),
          SizedBox(height: size.height * 0.01),
          InAppText(
            text: filterType == "All"
                ? "Create your first goal to get started"
                : "No goals in this category yet",
            size: 14,
            color: AppColors.grey,
            textAlign: TextAlign.center,
          ),
          if (filterType == "All") ...[
            SizedBox(height: size.height * 0.03),
            Visibility(
              visible: context.watch<AuthenticationCubit>().user.isMentee,
              child: AppButton(
                onTap: () => Navigator.pushNamed(context, Routename.addGoal),
                label: "Create Goal",
                buttonColor: AppColors.blue,
                width: size.width * 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final dynamic goal;
  final Size size;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.size,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final watchGoalCubit = context.watch<GoalCubit>();

    final feedback =
        watchGoalCubit.goalFeedback[goal.id] ?? {'has_feedback': false};
    final hasFeedback = feedback['has_feedback'] ?? false;
    final feedbackText = feedback['feedback_text'] ?? '';
    final feedbackRating = feedback['feedback_rating'] ?? 0;
    final mentorName = feedback['mentor_name'] ?? 'Mentor';

    return AppshadowContainer(
      onTap: onTap,
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      padding: EdgeInsets.all(size.width * 0.04),
      shadowcolour: AppColors.lightgrey.withAlpha(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InAppText(
                      text: goal.title,
                      size: 20,
                      fontweight: FontWeight.w700,
                      color: AppColors.blue,
                      maxline: 2,
                    ),
                    SizedBox(height: size.height * 0.005),
                    InAppText(
                      text:
                          "${_getCategoryIcon(goal.category)} ${goal.category.toUpperCase()}",
                      size: 12,
                      color: AppColors.grey,
                      fontweight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                color: AppColors.white,
                icon: Icon(Icons.more_vert, color: AppColors.blue),
                onSelected: (value) {
                  if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 18,
                          color: AppColors.errorColor,
                        ),
                        SizedBox(width: 8),
                        InAppText(text: 'Delete', color: AppColors.errorColor),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: size.height * 0.01),
          if (hasFeedback) ...[
            Container(
              padding: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(
                color: AppColors.filledColor.withAlpha(10),
                borderRadius: BorderRadius.circular(size.width * 0.02),
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
                      Row(
                        children: [
                          Icon(
                            Icons.feedback,
                            size: 16.sp,
                            color: AppColors.filledColor,
                          ),
                          SizedBox(width: size.width * 0.02),
                          InAppText(
                            text: "Mentor Feedback",
                            size: 13,
                            fontweight: FontWeight.w700,
                            color: AppColors.filledColor,
                          ),
                        ],
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < feedbackRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.orange.shade400,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.008),
                  InAppText(
                    text: feedbackText,
                    size: 14,
                    color: AppColors.lightblack,
                    maxline: 2,
                  ),
                  SizedBox(height: size.height * 0.005),
                  InAppText(
                    text: "— $mentorName",
                    size: 12,
                    color: AppColors.grey,
                    fontweight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ] else ...[
            InAppText(
              text: goal.description,
              size: 14,
              color: AppColors.grey,
              maxline: 2,
            ),
          ],

          SizedBox(height: size.height * 0.015),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InAppText(text: "Progress", size: 14, color: AppColors.grey),
              InAppText(
                text: "${goal.progressPercentage}%",
                size: 16,
                fontweight: FontWeight.w800,
                color: AppColors.filledColor,
              ),
            ],
          ),

          SizedBox(height: size.height * 0.01),

          Container(
            height: size.height * 0.012,
            width: size.width,
            decoration: BoxDecoration(
              color: AppColors.grey.withAlpha(30),
              borderRadius: BorderRadius.circular(size.width * 0.02),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: goal.progressPercentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.filledColor, AppColors.blue],
                      ),
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: size.height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.006,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(goal.status).withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getStatusColor(goal.status)),
                ),
                child: InAppText(
                  text: goal.status.toUpperCase(),
                  size: 12,
                  fontweight: FontWeight.bold,
                  color: _getStatusColor(goal.status),
                ),
              ),

              if (goal.deadline != null)
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
                    SizedBox(width: size.width * 0.01),
                    InAppText(
                      text: _formatDeadline(goal.deadline),
                      size: 12,
                      color: AppColors.grey,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'active':
        return Colors.blue;
      case 'abandoned':
        return Colors.red;
      default:
        return AppColors.grey;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'career':
        return '💼';
      case 'skill':
        return '🎯';
      case 'personal':
        return '☘️';
      default:
        return '📌';
    }
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;

    if (difference < 0) {
      return "Overdue";
    } else if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Tomorrow";
    } else if (difference < 7) {
      return "$difference days";
    } else {
      return "${deadline.day}/${deadline.month}/${deadline.year}";
    }
  }
}
