import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

class AchievementHistory extends StatelessWidget {
  const AchievementHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final achievements = [
      {
        'title': 'First Goal Completed',
        'description': 'Completed your first learning goal',
        'date': 'Dec 15, 2024',
        'icon': Icons.flag,
        'color': Colors.blue.shade400,
      },
      {
        'title': 'Consistent Learner',
        'description': '7 days streak of continuous learning',
        'date': 'Dec 10, 2024',
        'icon': Icons.local_fire_department,
        'color': Colors.orange.shade400,
      },
      {
        'title': 'Master Student',
        'description': 'Completed 10 sessions with mentor',
        'date': 'Dec 5, 2024',
        'icon': Icons.school,
        'color': Colors.purple.shade400,
      },
      {
        'title': 'Goal Setter',
        'description': 'Created 5 SMART goals',
        'date': 'Dec 1, 2024',
        'icon': Icons.check_circle,
        'color': Colors.green.shade400,
      },
      {
        'title': 'Quick Starter',
        'description': 'Completed first mentorship session',
        'date': 'Nov 28, 2024',
        'icon': Icons.rocket_launch,
        'color': Colors.pink.shade400,
      },
    ];

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            title: 'Achievement History',
            size: size,
            onTap: () => Navigator.pop(context),
          ),
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
                          color: AppColors.grey.withAlpha(30),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 60.sp,
                          color: AppColors.white,
                        ),
                        SizedBox(height: size.height * 0.015),
                        InAppText(
                          text: "${achievements.length} Achievements",
                          size: 24,
                          fontweight: FontWeight.w900,
                          color: AppColors.white,
                        ),
                        InAppText(
                          text: "Keep up the great work!",
                          size: 15,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(size.width * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.yellow.withAlpha(20),
                          borderRadius: BorderRadius.circular(
                            size.width * 0.02,
                          ),
                        ),
                        child: Icon(
                          Icons.emoji_events,
                          color: Colors.yellow.shade700,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      InAppText(
                        text: "Your Achievements",
                        size: 20,
                        fontweight: FontWeight.w700,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),
                  Column(
                    children: achievements.map((achievement) {
                      return AchievementWidget(
                        title: achievement['title'] as String,
                        description: achievement['description'] as String,
                        date: achievement['date'] as String,
                        icon: achievement['icon'] as IconData,
                        color: achievement['color'] as Color,
                        size: size,
                      );
                    }).toList(),
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

class AchievementWidget extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final IconData icon;
  final Color color;
  final Size size;

  const AchievementWidget({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      padding: EdgeInsets.all(size.width * 0.04),
      child: Row(
        children: [
          Container(
            width: size.width * 0.15,
            height: size.width * 0.15,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withAlpha(70)]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withAlpha(30),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.white, size: 30.sp),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InAppText(text: title, fontweight: FontWeight.w700),
                SizedBox(height: size.height * 0.005),
                InAppText(
                  text: description,
                  size: 15,
                  color: AppColors.grey,
                  maxline: 2,
                ),
                SizedBox(height: size.height * 0.006),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 17.sp,
                      color: AppColors.grey,
                    ),
                    SizedBox(width: size.width * 0.01),
                    InAppText(text: date, size: 14, color: AppColors.grey),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
