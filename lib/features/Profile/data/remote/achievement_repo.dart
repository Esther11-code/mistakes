import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

class AchievementRepo {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> checkPendingMentorshipAchievement(
    String menteeId,
  ) async {
    try {
      final existingAchievement = await supabase
          .from('user_achievements')
          .select('id')
          .eq('user_id', menteeId)
          .eq('achievement_type', 'first_mentorship_started')
          .maybeSingle();

      if (existingAchievement != null) {
        return null; // Already shown
      }

      // Check if they have an accepted mentorship
      final match = await supabase
          .from('matches')
          .select('mentor_id, welcome_message, responded_at')
          .eq('mentee_id', menteeId)
          .eq('status', 'accepted')
          .maybeSingle();

      if (match == null) return null;

      // Get mentor name
      final mentorProfile = await supabase
          .from('profiles')
          .select('full_name')
          .eq('user_id', match['mentor_id'])
          .single();

      return {
        'mentor_name': mentorProfile['full_name'] ?? 'Your mentor',
        'welcome_message': match['welcome_message'],
        'responded_at': match['responded_at'],
      };
    } catch (e) {
      log('Error checking pending mentorship achievement: $e');
      return null;
    }
  }

  // Save achievement
  Future<void> saveAchievement(
    String userId,
    String achievementType, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await supabase.from('user_achievements').insert({
        'user_id': userId,
        'achievement_type': achievementType,
        'metadata': metadata,
      });

      log('✅ Achievement saved: $achievementType');
    } catch (e) {
      log('❌ Error saving achievement: $e');
    }
  }
}