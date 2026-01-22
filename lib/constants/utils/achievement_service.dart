import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AchievementService {
  final supabase = Supabase.instance.client;
  Future<bool> hasAchieved(String achievementType) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return true;

      final response = await supabase
          .from('user_achievements')
          .select('id')
          .eq('user_id', userId)
          .eq('achievement_type', achievementType)
          .maybeSingle();

      return response != null;
    } catch (e) {
      log('Error checking achievement: $e');
      return true;
    }
  }

  Future<void> markAchieved(String achievementType, {Map<String, dynamic>? metadata}) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await supabase.from('user_achievements').insert({
        'user_id': userId,
        'achievement_type': achievementType,
        'metadata': metadata,
      });

      log('Achievement unlocked: $achievementType');
    } catch (e) {
      log('Error marking achievement: $e');
    }
  }
  Future<List<Map<String, dynamic>>> getUserAchievements(String userId) async {
    try {
      final response = await supabase
          .from('user_achievements')
          .select('achievement_type, achieved_at, metadata')
          .eq('user_id', userId)
          .order('achieved_at', ascending: false);
      return response.map<Map<String, dynamic>>((achievement) {
        final type = achievement['achievement_type'] as String;
        final achievedAt = DateTime.parse(achievement['achieved_at'] as String);
        final metadata = achievement['metadata'] as Map<String, dynamic>?;

        return {
          'title': _getAchievementTitle(type),
          'description': _getAchievementDescription(type, metadata),
          'date': DateFormat('MMM dd, yyyy').format(achievedAt),
          'icon': _getAchievementIcon(type),
          'color': _getAchievementColor(type),
        };
      }).toList();
    } catch (e) {
      log('Error fetching achievements: $e');
      return [];
    }
  }
  Future<int> getAchievementCount(String userId) async {
    try {
      final response = await supabase
          .from('user_achievements')
          .select('id')
          .eq('user_id', userId);

      return response.length;
    } catch (e) {
      log('Error getting achievement count: $e');
      return 0;
    }
  }
  String _getAchievementTitle(String type) {
    switch (type) {
      case 'first_goal_created':
        return 'First Goal Created';
      case 'first_goal_completed':
        return 'First Goal Completed';
      case 'first_bookmark_added':
        return 'First Mentor Saved';
      case 'first_mentorship_started':
        return 'Mentorship Started';
      case 'first_missed_deadline':
        return 'First Missed Deadline';
      case 'progress_50_percent':
        return '50% Progress Milestone';
      case 'progress_75_percent':
        return '75% Progress Milestone';
      case 'goal_completed':
        return 'Goal Completed';
      default:
        return 'Achievement Unlocked';
    }
  }

  String _getAchievementDescription(String type, Map<String, dynamic>? metadata) {
    switch (type) {
      case 'first_goal_created':
        return 'Created your first learning goal';
      case 'first_goal_completed':
        return 'Completed your first goal';
      case 'first_bookmark_added':
        return 'Bookmarked your first mentor';
      case 'first_mentorship_started':
        final mentorName = metadata?['mentor_name'] as String?;
        return 'Started mentorship with ${mentorName ?? 'your mentor'}';
      case 'first_missed_deadline':
        return 'Missed your first deadline (it happens!)';
      case 'progress_50_percent':
        return 'Reached 50% progress on a goal';
      case 'progress_75_percent':
        return 'Reached 75% progress on a goal';
      case 'goal_completed':
        return 'Completed a learning goal';
      default:
        return 'Unlocked an achievement';
    }
  }

  String _getAchievementIcon(String type) {
    switch (type) {
      case 'first_goal_created':
        return 'flag';
      case 'first_goal_completed':
        return 'trophy';
      case 'first_bookmark_added':
        return 'bookmark';
      case 'first_mentorship_started':
        return 'handshake';
      case 'first_missed_deadline':
        return 'heart_broken';
      case 'progress_50_percent':
      case 'progress_75_percent':
        return 'trending_up';
      case 'goal_completed':
        return 'check_circle';
      default:
        return 'star';
    }
  }

  String _getAchievementColor(String type) {
    switch (type) {
      case 'first_goal_created':
        return 'blue';
      case 'first_goal_completed':
        return 'amber';
      case 'first_bookmark_added':
        return 'purple';
      case 'first_mentorship_started':
        return 'green';
      case 'first_missed_deadline':
        return 'orange';
      case 'progress_50_percent':
      case 'progress_75_percent':
        return 'indigo';
      case 'goal_completed':
        return 'green';
      default:
        return 'blue';
    }
  }

  Future<void> markAchievedForUser(
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

    log('Achievement unlocked for user $userId: $achievementType');
  } catch (e) {
    log('Error marking achievement for user: $e');
  }
}
}