import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

class ProgressDashboard extends StatelessWidget {
  const ProgressDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            title: 'Progress Dashboard',
            size: size,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.025),
                  Container(
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
                                value: 0.75,
                                strokeWidth: 12,
                                backgroundColor: AppColors.blue.withAlpha(50),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                InAppText(
                                  text: "75%",
                                  size: 40,
                                  fontweight: FontWeight.w900,
                                  color: AppColors.white,
                                ),
                                InAppText(
                                  text: "Complete",
                                  size: 16,
                                  color: AppColors.white,
                                ),
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
                                  text: "8/10",
                                  size: 20,
                                  fontweight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                                InAppText(
                                  text: "Goals",
                                  size: 15,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                            HorizontalDivider(size: size),
                            Column(
                              children: [
                                InAppText(
                                  text: "15",
                                  size: 20,
                                  fontweight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                                InAppText(
                                  text: "Sessions",
                                  size: 15,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                            HorizontalDivider(size: size),
                            Column(
                              children: [
                                InAppText(
                                  text: "45",
                                  size: 20,
                                  fontweight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                                InAppText(
                                  text: "Days",
                                  size: 15,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(size.width * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(10),
                          borderRadius: BorderRadius.circular(
                            size.width * 0.05,
                          ),
                        ),
                        child: Icon(
                          Icons.flag_outlined,
                          color: Colors.green.shade600,
                          size: 25.sp,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      InAppText(
                        text: "Active Goals",
                        size: 20,
                        fontweight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),
                  Column(
                    children: List.generate(
                      3,
                      (index) => GoalProgressTracker(
                        goalName: index == 0
                            ? "Master Flutter"
                            : index == 1
                            ? "Learn System Design"
                            : "Improve Communication",
                        progress: index == 0
                            ? 0.8
                            : index == 1
                            ? 0.6
                            : 0.4,
                        color: index == 0
                            ? Colors.blue.shade400
                            : index == 1
                            ? Colors.purple.shade400
                            : Colors.orange.shade400,
                        size: size,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(size.width * 0.03),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withAlpha(10),
                          borderRadius: BorderRadius.circular(
                            size.width * 0.05,
                          ),
                        ),
                        child: Icon(
                          Icons.history,
                          color: AppColors.orange,
                          size: 25.sp,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      InAppText(
                        text: "Recent Activities",
                        size: 20,
                        fontweight: FontWeight.w700,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),

                  Column(
                    children: List.generate(4, (index) {
                      final activities = [
                        {
                          'icon': Icons.check_circle,
                          'text': 'Completed Flutter module',
                          'time': '2h ago',
                        },
                        {
                          'icon': Icons.book,
                          'text': 'Read System Design article',
                          'time': '5h ago',
                        },
                        {
                          'icon': Icons.video_library,
                          'text': 'Watched tutorial video',
                          'time': '1d ago',
                        },
                        {
                          'icon': Icons.chat,
                          'text': 'Had mentorship session',
                          'time': '2d ago',
                        },
                      ];
                      return RecentActivityContainer(
                        icon: activities[index]['icon'] as IconData,
                        text: activities[index]['text'] as String,
                        time: activities[index]['time'] as String,
                        size: size,
                      );
                    }),
                  ),

                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({super.key, required this.size, this.width, this.height, this.color});

  final Size size;
  final double? width,height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:width?? size.width * 0.004,
      height:height?? size.height * 0.05,
      color:color?? AppColors.white.withAlpha(70),
    );
  }
}

class GoalProgressTracker extends StatelessWidget {
  final String goalName;
  final double progress;
  final Color color;
  final Size size;

  const GoalProgressTracker({
    super.key,
    required this.goalName,
    required this.progress,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      padding: EdgeInsets.all(size.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InAppText(text: goalName, fontweight: FontWeight.w600),
              ),
              InAppText(
                text: "${(progress * 100).toInt()}%",
                fontweight: FontWeight.w700,
                color: color,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.012),
          Container(
            height: size.height * 0.015,
            width: size.width,
            decoration: BoxDecoration(
              color: AppColors.grey.withAlpha(30),
              borderRadius: BorderRadius.circular(size.width * 0.015),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withAlpha(70)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey.withAlpha(30),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecentActivityContainer extends StatelessWidget {
  final IconData icon;
  final String text;
  final String time;
  final Size size;

  const RecentActivityContainer({
    super.key,
    required this.icon,
    required this.text,
    required this.time,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      margin: EdgeInsets.only(bottom: size.height * 0.012),
      padding: EdgeInsets.all(size.width * 0.04),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.blue.withAlpha(10),
              borderRadius: BorderRadius.circular(size.width * 0.015),
            ),
            child: Icon(icon, color: AppColors.blue, size: 25.sp),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InAppText(
                  text: text,

                  fontweight: FontWeight.w500,
                  color: AppColors.blue,
                ),
                SizedBox(height: size.height * 0.005),
                InAppText(text: time, size: 15, color: AppColors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
