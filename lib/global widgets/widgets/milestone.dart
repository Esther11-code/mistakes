// lib/features/Profile/presentation/widgets/achievement_celebration.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

enum AchievementType {
  firstGoal,
  firstCompletedGoal,
  firstBookmark,
  mentorshipStarted, // ⭐ Changed from firstMentorship
  firstMissedDeadline,
  goalCompleted,
  progressMilestone,
}

class AchievementData {
  final AchievementType type;
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final bool showConfetti;
  final String? customMessage; // ⭐ For mentor's welcome message

  AchievementData({
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.showConfetti,
    this.customMessage,
  });

  static AchievementData fromType(
    AchievementType type, {
    String? customMessage,
    String? menteeName,
    String? mentorName,
    int? progressPercentage,
  }) {
    switch (type) {
      case AchievementType.firstGoal:
        return AchievementData(
          type: type,
          title: '🎯 First Goal Created!',
          message: 'You\'ve taken the first step in your mentorship journey. Keep setting goals to track your progress!',
          icon: Icons.flag_outlined,
          color: Colors.blue,
          showConfetti: true,
        );
      
      case AchievementType.firstCompletedGoal:
        return AchievementData(
          type: type,
          title: '🎉 First Goal Completed!',
          message: 'Amazing work! You\'ve completed your first goal. This is just the beginning of your success story!',
          icon: Icons.emoji_events,
          color: Colors.amber,
          showConfetti: true,
        );
      
      case AchievementType.goalCompleted:
        return AchievementData(
          type: type,
          title: '✅ Goal Completed!',
          message: 'Fantastic! You\'ve completed another goal. Keep up the momentum!',
          icon: Icons.check_circle,
          color: Colors.green,
          showConfetti: true,
        );
      
      case AchievementType.firstBookmark:
        return AchievementData(
          type: type,
          title: '⭐ First Mentor Saved!',
          message: 'Great choice! You\'ve bookmarked your first mentor. Building connections is key to growth!',
          icon: Icons.bookmark,
          color: Colors.purple,
          showConfetti: true,
        );
      
      case AchievementType.mentorshipStarted:
        return AchievementData(
          type: type,
          title: '🤝 Mentorship Started!',
          message: customMessage ?? 
              'Your mentorship journey with ${mentorName ?? 'your mentor'} begins now! Work closely together to achieve your goals.',
          icon: Icons.handshake_rounded,
          color: Colors.green,
          showConfetti: true,
          customMessage: customMessage,
        );
      
      case AchievementType.firstMissedDeadline:
        return AchievementData(
          type: type,
          title: '⏰ Deadline Missed',
          message: 'Don\'t worry! Missing a deadline happens. Reach out to your mentor to get back on track.',
          icon: Icons.schedule,
          color: Colors.orange,
          showConfetti: false,
        );
      
      case AchievementType.progressMilestone:
        return AchievementData(
          type: type,
          title: '🎊 ${progressPercentage ?? 50}% Complete!',
          message: 'You\'re making great progress! Keep going, you\'re more than halfway there!',
          icon: Icons.trending_up,
          color: Colors.indigo,
          showConfetti: true,
        );
    }
  }
}

class AchievementCelebration extends StatefulWidget {
  final AchievementType achievementType;
  final String? customMessage; // ⭐ Mentor's welcome message
  final String? menteeName;
  final String? mentorName;
  final int? progressPercentage;
  final VoidCallback? onContinue;
  final String? continueButtonText;

  const AchievementCelebration({
    super.key,
    required this.achievementType,
    this.customMessage,
    this.menteeName,
    this.mentorName,
    this.progressPercentage,
    this.onContinue,
    this.continueButtonText,
  });

  @override
  State<AchievementCelebration> createState() => _AchievementCelebrationState();
}

class _AchievementCelebrationState extends State<AchievementCelebration>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    final achievement = AchievementData.fromType(
      widget.achievementType,
      customMessage: widget.customMessage,
      menteeName: widget.menteeName,
      mentorName: widget.mentorName,
      progressPercentage: widget.progressPercentage,
    );
    
    _confettiController = ConfettiController(
      duration: Duration(seconds: achievement.showConfetti ? 3 : 0),
    );
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    
    _animationController.forward();
    if (achievement.showConfetti) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final achievement = AchievementData.fromType(
      widget.achievementType,
      customMessage: widget.customMessage,
      menteeName: widget.menteeName,
      mentorName: widget.mentorName,
      progressPercentage: widget.progressPercentage,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Confetti
          if (achievement.showConfetti)
            Positioned(
              top: 0,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: [
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.red,
                  Colors.purple,
                ],
                numberOfParticles: 30,
                gravity: 0.3,
              ),
            ),
          
          // Content Card
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                padding: EdgeInsets.all(size.width * 0.06),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            achievement.color,
                            achievement.color.withOpacity(0.7),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: achievement.color.withOpacity(0.4),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        achievement.icon,
                        size: 50.sp,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.03),
                    
                    // Title
                    InAppText(
                      text: achievement.title,
                      size: 24,
                      fontweight: FontWeight.w700,
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
                    
                    // ⭐ Show custom message if it's a mentorship and there's a welcome message
                    if (widget.achievementType == AchievementType.mentorshipStarted && 
                        widget.customMessage != null && 
                        widget.customMessage!.isNotEmpty) ...[
                      SizedBox(height: size.height * 0.02),
                      
                      Container(
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: BoxDecoration(
                          color: achievement.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: achievement.color.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.message_outlined,
                                  size: 18.sp,
                                  color: achievement.color,
                                ),
                                SizedBox(width: 8),
                                InAppText(
                                  text: 'Message from ${widget.mentorName ?? "your mentor"}:',
                                  size: 14,
                                  fontweight: FontWeight.w600,
                                  color: achievement.color,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            InAppText(
                              text: '"${widget.customMessage}"',
                              size: 14,
                              color: AppColors.lightblack,
                              textAlign: TextAlign.left,
                              maxline: 10,
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
                      buttonColor: achievement.color,
                      label: widget.continueButtonText ?? 'Continue',
                      textSize: 17,
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

// ⭐ Helper function to show achievement
void showAchievementCelebration(
  BuildContext context,
  AchievementType type, {
  String? customMessage,
  String? menteeName,
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
      customMessage: customMessage,
      menteeName: menteeName,
      mentorName: mentorName,
      progressPercentage: progressPercentage,
      onContinue: onContinue,
      continueButtonText: continueButtonText,
    ),
  );
}

// // In _MentorshipRequestState._showSuccessDialog(), replace with:

// void _showSuccessDialog() {
//   final cubit = context.read<MentorCubit>();
//   final menteeName = cubit.selectedMenteeName;
//   final firstName = menteeName.split(' ')[0];
//   final welcomeMessage = _welcomeMessageController.text.trim();
  
//   // ⭐ Show achievement celebration instead of simple dialog
//   showAchievementCelebration(
//     context,
//     AchievementType.mentorshipStarted,
//     customMessage: welcomeMessage.isEmpty ? null : welcomeMessage,
//     menteeName: firstName,
//     mentorName: 'you', // Or get actual mentor name from context
//     onContinue: () {
//       // Pop AcceptMentorship page
//       Navigator.pop(context);
//       // Pop RequestDetails page
//       Navigator.pop(context);
//     },
//     continueButtonText: 'Start Mentoring',
//   );
// }




enum MilestoneType {
  firstGoal,
  firstCompletedGoal,
  firstBookmark,
  firstMentorship,
  firstMissedDeadline,
}

class MilestoneData {
  final MilestoneType type;
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final bool isPositive;

  MilestoneData({
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.isPositive,
  });

  static MilestoneData fromType(MilestoneType type) {
    switch (type) {
      case MilestoneType.firstGoal:
        return MilestoneData(
          type: type,
          title: '🎯 First Goal Created!',
          message: 'You\'ve taken the first step in your mentorship journey. Keep setting goals to track your progress!',
          icon: Icons.flag_outlined,
          color: Colors.blue,
          isPositive: true,
        );
      
      case MilestoneType.firstCompletedGoal:
        return MilestoneData(
          type: type,
          title: '🎉 First Goal Completed!',
          message: 'Amazing work! You\'ve completed your first goal. This is just the beginning of your success story!',
          icon: Icons.emoji_events,
          color: Colors.amber,
          isPositive: true,
        );
      
      case MilestoneType.firstBookmark:
        return MilestoneData(
          type: type,
          title: '⭐ First Mentor Saved!',
          message: 'Great choice! You\'ve bookmarked your first mentor. Building connections is key to growth!',
          icon: Icons.bookmark,
          color: Colors.purple,
          isPositive: true,
        );
      
      case MilestoneType.firstMentorship:
        return MilestoneData(
          type: type,
          title: '🤝 Mentorship Started!',
          message: 'Your mentorship journey begins now! Work closely with your mentor to achieve your goals.',
          icon: Icons.handshake_rounded,
          color: Colors.green,
          isPositive: true,
        );
      
      case MilestoneType.firstMissedDeadline:
        return MilestoneData(
          type: type,
          title: '⏰ Deadline Missed',
          message: 'Don\'t worry! Missing a deadline happens. Reach out to your mentor to get back on track.',
          icon: Icons.schedule,
          color: Colors.orange,
          isPositive: false,
        );
    }
  }
}

class MilestoneCelebration extends StatefulWidget {
  final MilestoneType milestoneType;
  final VoidCallback? onContinue;

  const MilestoneCelebration({
    super.key,
    required this.milestoneType,
    this.onContinue,
  });

  @override
  State<MilestoneCelebration> createState() => _MilestoneCelebrationState();
}

class _MilestoneCelebrationState extends State<MilestoneCelebration>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    final milestone = MilestoneData.fromType(widget.milestoneType);
    
    // Only show confetti for positive milestones
    _confettiController = ConfettiController(
      duration: Duration(seconds: milestone.isPositive ? 3 : 0),
    );
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    
    // Start animations
    _animationController.forward();
    if (milestone.isPositive) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final milestone = MilestoneData.fromType(widget.milestoneType);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Confetti
          if (milestone.isPositive)
            Positioned(
              top: 0,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: [
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.red,
                  Colors.purple,
                ],
                numberOfParticles: 30,
                gravity: 0.3,
              ),
            ),
          
          // Content Card
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                padding: EdgeInsets.all(size.width * 0.06),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            milestone.color,
                            milestone.color.withOpacity(0.7),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: milestone.color.withOpacity(0.4),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        milestone.icon,
                        size: 50.sp,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.03),
                    
                    // Title
                    InAppText(
                      text: milestone.title,
                      size: 24,
                      fontweight: FontWeight.w700,
                      color: AppColors.blue,
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: size.height * 0.015),
                    
                    // Message
                    InAppText(
                      text: milestone.message,
                      size: 16,
                      color: AppColors.grey,
                      textAlign: TextAlign.center,
                      maxline: 5,
                    ),
                    
                    SizedBox(height: size.height * 0.03),
                    
                    // Continue Button
                    AppButton(
                      onTap: () {
                        Navigator.pop(context);
                        widget.onContinue?.call();
                      },
                      width: size.width,
                      buttonColor: milestone.color,
                      label: 'Continue',
                      textSize: 17,
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

// Helper function to show milestone
void showMilestoneCelebration(
  BuildContext context,
  MilestoneType type, {
  VoidCallback? onContinue,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => MilestoneCelebration(
      milestoneType: type,
      onContinue: onContinue,
    ),
  );
}