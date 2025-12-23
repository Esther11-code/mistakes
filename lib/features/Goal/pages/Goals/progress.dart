import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/features/Goal/pages/Goals/goal_setup.dart';
import 'package:mistakes/global%20widgets/export.dart';
import 'package:mistakes/global%20widgets/widgets/app_scaffold.dart';
import 'package:mistakes/global%20widgets/widgets/appbar.dart';

import '../../../../constants/utils/app_colors.dart';

class ProgressDashboard extends StatelessWidget {
  const ProgressDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            size: size,
            title: "Progress Dashboard",
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // Add your progress dashboard content here
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
                    AppshadowContainer(
                      padding: EdgeInsets.all(size.width * 0.045),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      color: AppColors.white,
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.02),
                          CircularProgressWithPercentage(
                            textSize: 22,
                            percentage: 0.50, // 65% complete
                            size: 150,
                            strokeWidth: size.width * 0.03,
                            progressColor: AppColors.filledColor,
                            backgroundColor: AppColors.grey,
                            textColor: AppColors.blue,
                          ),
                          SizedBox(height: size.height * 0.028),
                          AppText(
                            text: "Overall Progress",
                            fontweight: FontWeight.w500,
                            color: AppColors.blue.withAlpha(100),
                          ),
                          AppText(
                            text: "3 months with Mentor Jane Doe",
                            size: 20,
                            color: AppColors.blue,
                            fontweight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),
                    AppText(
                      text: "Skills Gained",
                      size: 20,
                      fontweight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: size.width * 0.02,
                      runSpacing: size.height * 0.02,
                      children: List.generate(
                        7,
                        (index) => IntrinsicWidth(
                          // Add this
                          child: AppshadowContainer(
                            radius: size.height * 0.05,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.01,
                            ),
                            border: true,
                            borderColor: AppColors.background,
                            color: AppColors.inactive,
                            child: AppText(
                              text: "HTML",
                              color: AppColors.blue,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    AppText(
                      text: "Milestones",
                      size: 20,
                      fontweight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                    // Add your progress content here
                    Column(
                      children: List.generate(
                        5,
                        (index) => AppshadowContainer(
                          shadowcolour: AppColors.lightgrey.withAlpha(50),
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                            vertical: size.width * 0.04,
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: size.width * 0.02,
                          ),
                          width: size.width,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: size.height * 0.03,
                                backgroundColor: AppColors.blue,
                                child: Icon(
                                  Icons.notifications,
                                  color: AppColors.white,
                                  size: 25.sp,
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: 'Great Deals',
                                    color: AppColors.blue,
                                    size: 20,
                                    fontweight: FontWeight.w700,
                                  ),
                                  AppText(
                                    text: '1h ago',
                                    size: 14,
                                    fontweight: FontWeight.w700,
                                    color: AppColors.blue.withAlpha(70),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
