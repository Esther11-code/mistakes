// lib/features/Profile/presentation/widgets/achievement_celebration.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';
import 'package:mistakes/constants/utils/achievement_service.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

enum AchievementType {
  firstGoal,
  firstCompletedGoal,
  firstBookmark,
  mentorshipStarted,
  firstMissedDeadline,
  goalCompleted,
  progressMilestone,
}

class AchievementData {
  final AchievementType type;
  final String title;
  final String message;
  final IconData icon;
  final List<Color> gradientColors;
  final bool showConfetti;

  AchievementData({
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
    required this.gradientColors,
    required this.showConfetti,
  });

  static AchievementData fromType(
    AchievementType type, {
    int? progressPercentage,
  }) {
    switch (type) {
      case AchievementType.firstGoal:
        return AchievementData(
          type: type,
          title: 'First Goal Created!',
          message:
              'You\'ve taken the first step in your mentorship journey. Keep setting goals to track your progress!',
          icon: Icons.flag_rounded,
          gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
          showConfetti: true,
        );

      case AchievementType.firstCompletedGoal:
        return AchievementData(
          type: type,
          title: 'First Goal Completed!',
          message:
              'Amazing work! You\'ve completed your first goal. This is just the beginning of your success story!',
          icon: Icons.emoji_events,
          gradientColors: [Colors.amber.shade400, Colors.orange.shade600],
          showConfetti: true,
        );

      case AchievementType.goalCompleted:
        return AchievementData(
          type: type,
          title: 'Goal Completed!',
          message:
              'Fantastic! You\'ve completed another goal. Keep up the momentum!',
          icon: Icons.check_circle_rounded,
          gradientColors: [Colors.green.shade400, Colors.green.shade600],
          showConfetti: true,
        );

      case AchievementType.firstBookmark:
        return AchievementData(
          type: type,
          title: 'First Mentor Saved!',
          message:
              'Great choice! You\'ve bookmarked your first mentor. Building connections is key to growth!',
          icon: Icons.bookmark_rounded,
          gradientColors: [Colors.purple.shade400, Colors.purple.shade600],
          showConfetti: true,
        );

      case AchievementType.mentorshipStarted:
        return AchievementData(
          type: type,
          title: 'Mentorship Started!',
          message:
              'Your mentorship journey begins now! Work closely together to achieve your goals.',
          icon: Icons.handshake_rounded,
          gradientColors: [AppColors.background, AppColors.filledColor],
          showConfetti: true,
        );

      case AchievementType.firstMissedDeadline:
        return AchievementData(
          type: type,
          title: 'Deadline Missed',
          message:
              'Don\'t worry! Missing a deadline happens. Reach out to your mentor to get back on track.',
          icon: Icons.heart_broken_rounded,
          gradientColors: [Colors.orange.shade400, Colors.red.shade400],
          showConfetti: false,
        );

      case AchievementType.progressMilestone:
        return AchievementData(
          type: type,
          title: '${progressPercentage ?? 50}% Complete!',
          message:
              'You\'re making great progress! Keep going, you\'re ${progressPercentage != null && progressPercentage >= 50 ? 'more than halfway' : 'on your way'} there!',
          icon: Icons.trending_up_rounded,
          gradientColors: [Colors.indigo.shade400, Colors.purple.shade600],
          showConfetti: true,
        );
    }
  }
}

class AchievementCelebration extends StatefulWidget {
  final AchievementType achievementType;
  final String? welcomeMessage;
  final String? mentorName;
  final int? progressPercentage;
  final VoidCallback? onContinue;
  final String? continueButtonText;

  const AchievementCelebration({
    super.key,
    required this.achievementType,
    this.welcomeMessage,
    this.mentorName,
    this.progressPercentage,
    this.onContinue,
    this.continueButtonText,
  });

  @override
  State<AchievementCelebration> createState() => _AchievementCelebrationState();
}

class _AchievementCelebrationState extends State<AchievementCelebration>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    final achievement = AchievementData.fromType(
      widget.achievementType,
      progressPercentage: widget.progressPercentage,
    );

    _confettiController = ConfettiController(
      duration: Duration(seconds: achievement.showConfetti ? 4 : 0),
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeIn,
    );

    _scaleController.forward();
    _slideController.forward();

    if (achievement.showConfetti) {
      Future.delayed(Duration(milliseconds: 300), () {
        _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final achievement = AchievementData.fromType(
      widget.achievementType,
      progressPercentage: widget.progressPercentage,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Confetti
          if (achievement.showConfetti)
            Positioned(
              top: -50,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: [
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.red,
                  Colors.purple,
                  Colors.pink,
                ],
                numberOfParticles: 40,
                gravity: 0.2,
                emissionFrequency: 0.05,
              ),
            ),

          // Main Content
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: EdgeInsets.all(size.width * 0.06),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: achievement.gradientColors.first.withAlpha(50),
                      blurRadius: 30,
                      offset: Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Icon
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: achievement.gradientColors,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: achievement.gradientColors.first.withAlpha(
                                80,
                              ),
                              blurRadius: 25,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Icon(
                          achievement.icon,
                          size: 60.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    // Title
                    InAppText(
                      text: achievement.title,
                      size: 26,
                      fontweight: FontWeight.w800,
                      color: AppColors.blue,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: size.height * 0.015),

                    // Message
                    InAppText(
                      text: achievement.message,
                      size: 16,
                      color: AppColors.grey,
                      textAlign: TextAlign.center,
                      maxline: 10,
                    ),

                    // Welcome Message Card (only for mentorship started)
                    if (widget.achievementType ==
                            AchievementType.mentorshipStarted &&
                        widget.welcomeMessage != null &&
                        widget.welcomeMessage!.isNotEmpty) ...[
                      SizedBox(height: size.height * 0.025),
                      Container(
                        width: size.width,
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.background.withAlpha(20),
                              AppColors.filledColor.withAlpha(20),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.filledColor.withAlpha(50),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.background,
                                        AppColors.filledColor,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.mail_outline_rounded,
                                    size: 18.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: InAppText(
                                    text:
                                        '${widget.mentorName ?? "Your mentor"} says:',
                                    size: 15,
                                    fontweight: FontWeight.w700,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Container(
                              padding: EdgeInsets.all(size.width * 0.03),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InAppText(
                                text: '"${widget.welcomeMessage}"',
                                size: 15,
                                color: AppColors.lightblack,
                                textAlign: TextAlign.left,
                                maxline: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: size.height * 0.03),

                    // Continue Button
                    AppButton(
                      onTap: () {
                        Navigator.pop(context);
                        widget.onContinue?.call();
                      },
                      width: size.width,
                      label: widget.continueButtonText ?? 'Continue',
                      textSize: 17,
                      buttonColor: AppColors.background,
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

// Helper function to show achievement
void showAchievementCelebration(
  BuildContext context,
  AchievementType type, {
  String? welcomeMessage,
  String? mentorName,
  int? progressPercentage,
  VoidCallback? onContinue,
  String? continueButtonText,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AchievementCelebration(
      achievementType: type,
      welcomeMessage: welcomeMessage,
      mentorName: mentorName,
      progressPercentage: progressPercentage,
      onContinue: onContinue,
      continueButtonText: continueButtonText,
    ),
  );
}

// Helper to check and show achievement
Future<void> checkAndShowAchievement(
  BuildContext context,
  String achievementKey,
  AchievementType achievementType, {
  String? welcomeMessage,
  String? mentorName,
  int? progressPercentage,
  VoidCallback? onContinue,
  String? continueButtonText,
}) async {
  final service = AchievementService();

  // Check if already achieved
  final alreadyAchieved = await service.hasAchieved(achievementKey);

  if (!alreadyAchieved) {
    // Mark as achieved
    await service.markAchieved(
      achievementKey,
      metadata: {
        'mentor_name': mentorName,
        'welcome_message': welcomeMessage,
        'progress_percentage': progressPercentage,
      },
    );

    // Show celebration
    if (context.mounted) {
      showAchievementCelebration(
        context,
        achievementType,
        welcomeMessage: welcomeMessage,
        mentorName: mentorName,
        progressPercentage: progressPercentage,
        onContinue: onContinue,
        continueButtonText: continueButtonText,
      );
    }
  }
}
