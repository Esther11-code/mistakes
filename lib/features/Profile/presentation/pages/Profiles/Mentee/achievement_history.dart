// lib/features/Profile/presentation/pages/achievement_history.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/constants/utils/achievement_service.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AchievementHistory extends StatefulWidget {
  const AchievementHistory({super.key});

  @override
  State<AchievementHistory> createState() => _AchievementHistoryState();
}

class _AchievementHistoryState extends State<AchievementHistory> {
  final _achievementService = AchievementService();
  List<Map<String, dynamic>> _achievements = [];
  int _achievementCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() => _isLoading = true);

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      final achievements = await _achievementService.getUserAchievements(
        userId,
      );
      final count = await _achievementService.getAchievementCount(userId);

      setState(() {
        _achievements = achievements;
        _achievementCount = count;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            title: 'Achievement History',
            size: size,
            onTap: () => Navigator.pop(context),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: AppColors.background,
                      size: 60.sp,
                    ),
                  )
                : _achievements.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 80.sp,
                          color: AppColors.lightgrey,
                        ),
                        SizedBox(height: size.height * 0.02),
                        InAppText(
                          text: 'No achievements yet',
                          size: 20,
                          fontweight: FontWeight.w600,
                          color: AppColors.grey,
                        ),
                        SizedBox(height: size.height * 0.01),
                        InAppText(
                          text: 'Start your journey to unlock achievements!',
                          size: 15,
                          color: AppColors.lightgrey,
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadAchievements,
                    color: AppColors.filledColor,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
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
                                colors: [
                                  AppColors.background,
                                  AppColors.filledColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                size.width * 0.05,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.filledColor.withAlpha(50),
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
                                  text:
                                      "$_achievementCount ${_achievementCount == 1 ? 'Achievement' : 'Achievements'}",
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
                            children: _achievements.map((achievement) {
                              return AchievementWidget(
                                title: achievement['title'] as String,
                                description:
                                    achievement['description'] as String,
                                date: achievement['date'] as String,
                                iconName: achievement['icon'] as String,
                                colorName: achievement['color'] as String,
                                size: size,
                              );
                            }).toList(),
                          ),
                          SizedBox(height: size.height * 0.03),
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

class AchievementWidget extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String iconName;
  final String colorName;
  final Size size;

  const AchievementWidget({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.iconName,
    required this.colorName,
    required this.size,
  });

  IconData _getIcon(String name) {
    switch (name) {
      case 'flag':
        return Icons.flag_rounded;
      case 'trophy':
        return Icons.emoji_events;
      case 'bookmark':
        return Icons.bookmark_rounded;
      case 'handshake':
        return Icons.handshake_rounded;
      case 'heart_broken':
        return Icons.heart_broken_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'check_circle':
        return Icons.check_circle_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  Color _getColor(String name) {
    switch (name) {
      case 'blue':
        return Colors.blue.shade400;
      case 'amber':
        return Colors.amber.shade400;
      case 'purple':
        return Colors.purple.shade400;
      case 'green':
        return Colors.green.shade400;
      case 'orange':
        return Colors.orange.shade400;
      case 'indigo':
        return Colors.indigo.shade400;
      default:
        return Colors.blue.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(colorName);
    final icon = _getIcon(iconName);

    return AppshadowContainer(
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      padding: EdgeInsets.all(size.width * 0.04),
      child: Row(
        children: [
          Container(
            width: size.width * 0.15,
            height: size.width * 0.15,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withAlpha(150)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(50),
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
                InAppText(
                  text: title,
                  fontweight: FontWeight.w700,
                  color: AppColors.blue,
                ),
                SizedBox(height: size.height * 0.005),
                InAppText(
                  text: description,
                  size: 15,
                  color: AppColors.blackColor,
                  maxline: 2,
                ),
                SizedBox(height: size.height * 0.006),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14.sp,
                      color: AppColors.lightblack,
                    ),
                    SizedBox(width: size.width * 0.01),
                    InAppText(
                      text: date,
                      size: 13,
                      color: AppColors.lightblack,
                    ),
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
