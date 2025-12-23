import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Goal/pages/Goals/mentee/mentee_goal.dart';
import 'package:mistakes/features/Home/data/local/images/home_image.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';


class GoalSetup extends StatelessWidget {
  const GoalSetup({super.key});

  @override
  Widget build(BuildContext context) {
   final watchAuthCubit = context.watch<AuthenticationCubit>();
    return watchAuthCubit.user.role == "Mentee"
        ? const MenteeGoal()
        : const MenteeGoal();
  }
}

class GoalContainer extends StatelessWidget {
  const GoalContainer({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(size.width * 0.03),
      shadowcolour: AppColors.lightgrey.withAlpha(100),
      margin: EdgeInsets.symmetric(vertical: size.height * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppText(
                    text: "Lorem ipsum",
                    color: AppColors.blue,
                    size: 20,
                    fontweight: FontWeight.w600,
                  ),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.clock,
                        size: 20.sp,
                        color: AppColors.blue.withAlpha(100),
                      ),
                      SizedBox(width: size.width * 0.02),
                      AppText(
                        text: "Next Month - 12:45PM",
                        color: AppColors.blue.withAlpha(100),
                        size: 16,
                        fontweight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
              AppshadowContainer(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.01,
                ),
                border: true,
                borderColor: AppColors.orange.withAlpha(100),
                color: AppColors.orange.withAlpha(75),
                child: AppText(
                  text: "Ongoing",
                  color: AppColors.orange,
                  fontweight: FontWeight.w500,
                  size: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          AppDivider(),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    HomeImages.avatar,
                    height: size.height * 0.08,
                    width: size.width * 0.12,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: size.width * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Mentor review",
                        color: AppColors.blue,
                        size: 20,
                        fontweight: FontWeight.w600,
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: AppText(
                          text:
                              "\"Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor\"",
                          color: AppColors.blue.withAlpha(100),
                          size: 16,
                          fontweight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CircularProgressWithPercentage(
                percentage: 0.50, // 65% complete
                size: 80,
                strokeWidth: size.width * 0.01,
                progressColor: AppColors.filledColor,
                backgroundColor: AppColors.grey,
                textColor: AppColors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Simple Circular Progress with Percentage
class CircularProgressWithPercentage extends StatelessWidget {
  final double percentage; // 0.0 to 1.0 (e.g., 0.75 for 75%)
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final Color textColor;
  final double? textSize;

  const CircularProgressWithPercentage({
    super.key,
    required this.percentage,
    this.size = 120,
    this.strokeWidth = 12,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.black,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 0.7,
      height: size * 0.7,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Progress Indicator
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage,
              strokeWidth: strokeWidth,
              backgroundColor: backgroundColor.withAlpha(30),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              strokeCap: StrokeCap.round, // Rounded edges
            ),
          ),
          // Percentage Text in Center
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: '${(percentage * 100).toInt()}%',

                size: textSize ?? 16,
                fontweight: FontWeight.w500,
                color: textColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Usage Example:
