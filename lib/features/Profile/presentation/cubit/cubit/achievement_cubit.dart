import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mistakes/features/Profile/data/remote/achievement_repo.dart';

part 'achievement_state.dart';

class AchievementCubit extends Cubit<AchievementState> {
 AchievementRepo achievementRepo;

  AchievementCubit(this.achievementRepo) : super(AchievementInitial());

  Map<String, dynamic>? pendingMentorshipAchievement;

  // Check for pending mentorship achievement
  Future<void> checkPendingMentorshipAchievement(String menteeId) async {
    try {
      pendingMentorshipAchievement = 
          await achievementRepo.checkPendingMentorshipAchievement(menteeId);
      
      if (pendingMentorshipAchievement != null) {
        log('📬 Found pending mentorship achievement');
        emit(AchievementPendingState());
      } else {
        emit(AchievementNoPendingState());
      }
    } catch (e) {
      log('Error checking pending achievement: $e');
      emit(AchievementNoPendingState());
    }
  }

  // Mark achievement as shown
  Future<void> markAchievementShown(String achievementType) async {
    try {
      // This will be handled by checkAndShowAchievement
      emit(AchievementShownState());
    } catch (e) {
      log('Error marking achievement shown: $e');
    }
  }
}