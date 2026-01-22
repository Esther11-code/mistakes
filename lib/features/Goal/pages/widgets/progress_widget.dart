
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';

class EmptyGoalsState extends StatelessWidget {
  final Size size;

  const EmptyGoalsState({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.track_changes,
              size: 100,
              color: AppColors.grey.withAlpha(100),
            ),
            SizedBox(height: size.height * 0.03),
            InAppText(
              text: "No Goals Yet",
              size: 24,
              fontweight: FontWeight.bold,
              color: AppColors.blue,
            ),
            SizedBox(height: size.height * 0.02),
            InAppText(
              text: "Create goals to track your progress",
              size: 16,
              color: AppColors.grey,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.04),
            Visibility(
              visible: context.watch<AuthenticationCubit>().user.isMentee,
              child: AppButton(
                onTap: () => Navigator.pushNamed(context, Routename.goalSetUp),
                label: "Create Goal",
                buttonColor: AppColors.filledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OverallProgressCard extends StatelessWidget {
  final Size size;
  final int overallProgress;
  final int completedGoals;
  final int totalGoals;
  final int activeGoals;

  const OverallProgressCard({
    super.key,
    required this.size,
    required this.overallProgress,
    required this.completedGoals,
    required this.totalGoals,
    required this.activeGoals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.background, AppColors.filledColor],
        ),
        borderRadius: BorderRadius.circular(size.width * 0.05),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withAlpha(80),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          InAppText(
            text: "Overall Progress",
            size: 20,
            fontweight: FontWeight.w600,
            color: AppColors.white,
          ),
          SizedBox(height: size.height * 0.025),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size.width * 0.45,
                height: size.width * 0.45,
                child: CircularProgressIndicator(
                  value: overallProgress / 100,
                  strokeWidth: 12,
                  backgroundColor: AppColors.blue.withAlpha(50),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              ),
              Column(
                children: [
                  InAppText(
                    text: "$overallProgress%",
                    size: 40,
                    fontweight: FontWeight.w900,
                    color: AppColors.white,
                  ),
                  InAppText(text: "Complete", size: 16, color: AppColors.white),
                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  InAppText(
                    text: "$completedGoals/$totalGoals",
                    size: 20,
                    fontweight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  InAppText(text: "Goals", size: 15, color: AppColors.white),
                ],
              ),
              Container(
                width: size.width * 0.004,
                height: size.height * 0.05,
                color: AppColors.white.withAlpha(70),
              ),
              Column(
                children: [
                  InAppText(
                    text: "$activeGoals",
                    size: 20,
                    fontweight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  InAppText(text: "Active", size: 15, color: AppColors.white),
                ],
              ),
              Container(
                width: size.width * 0.004,
                height: size.height * 0.05,
                color: AppColors.white.withAlpha(70),
              ),
              Column(
                children: [
                  InAppText(
                    text: "${totalGoals - completedGoals}",
                    size: 20,
                    fontweight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  InAppText(
                    text: "Remaining",
                    size: 15,
                    color: AppColors.white,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GoalProgressCard extends StatelessWidget {
  final dynamic goal; 
  final Size size;
  final Function(int) onProgressUpdate;

  const GoalProgressCard({
    super.key,
    required this.goal,
    required this.size,
    required this.onProgressUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      padding: EdgeInsets.all(size.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal Title and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InAppText(
                  text: goal.title,
                  fontweight: FontWeight.w700,
                  size: 18,
                  color: AppColors.blue,
                ),
              ),
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
                  text: goal.status.toString().toUpperCase(),
                  size: 12,
                  fontweight: FontWeight.bold,
                  color: _getStatusColor(goal.status),
                ),
              ),
            ],
          ),

          SizedBox(height: size.height * 0.012),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: size.height * 0.015,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withAlpha(30),
                    borderRadius: BorderRadius.circular(size.width * 0.015),
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.03),
              InAppText(
                text: "${goal.progressPercentage}%",
                fontweight: FontWeight.w700,
                color: AppColors.filledColor,
                size: 18,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InAppText(
                text: "Update:",
                size: 14,
                fontweight: FontWeight.w600,
                color: AppColors.blue,
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    color: AppColors.errorColor,
                    iconSize: 28.sp,
                    onPressed: goal.progressPercentage > 0
                        ? () => onProgressUpdate(
                            (goal.progressPercentage - 10).clamp(0, 100),
                          )
                        : null,
                  ),
                  SizedBox(width: size.width * 0.02),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    color: AppColors.filledColor,
                    iconSize: 28.sp,
                    onPressed: goal.progressPercentage < 100
                        ? () => onProgressUpdate(
                            (goal.progressPercentage + 10).clamp(0, 100),
                          )
                        : null,
                  ),
                ],
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [25, 50, 75, 100].map((value) {
              final isSelected = goal.progressPercentage == value;
              return GestureDetector(
                onTap: () => onProgressUpdate(value),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.filledColor
                        : AppColors.filledColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.filledColor),
                  ),
                  child: InAppText(
                    text: "$value%",
                    size: 14,
                    fontweight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.filledColor,
                  ),
                ),
              );
            }).toList(),
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
}
