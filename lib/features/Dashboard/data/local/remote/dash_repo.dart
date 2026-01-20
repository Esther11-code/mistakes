// lib/features/Dashboard/data/local/remote/dash_repo.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:mistakes/features/Dashboard/data/local/model/mentor_model.dart';

class DashboardRepo {
  final _supabase = Supabase.instance.client;

  // ============================================================================
  // GET MENTEES FOR MENTOR
  // ============================================================================
  Future<List<MenteeModel>> getMentees({required String mentorId}) async {
    try {
      log('Fetching mentees for mentor: $mentorId');

      // Get all accepted mentorships
      final matchesResponse = await _supabase
          .from('matches')
          .select('id, created_at, mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted')
          .order('created_at', ascending: false);

      if (matchesResponse.isEmpty) {
        log('No active mentees found');
        return [];
      }

      final mentees = <MenteeModel>[];

      for (var match in matchesResponse) {
        final menteeId = match['mentee_id'] as String;
        final matchId = match['id'] as String;

        try {
          // Get mentee profile
          final profileResponse = await _supabase
              .from('profiles')
              .select('full_name, username, profile_photo_url, expertise')
              .eq('user_id', menteeId)
              .single();

          // Get mentee's goals
          final goalsResponse = await _supabase
              .from('goals')
              .select('*')
              .eq('mentee_id', menteeId)
              .order('created_at', ascending: false);

          // Calculate stats
          final totalGoals = goalsResponse.length;
          final completedGoals = goalsResponse
              .where((g) => g['status'] == 'completed')
              .length;
          final activeGoals = goalsResponse
              .where((g) => g['status'] == 'active')
              .length;

          // Calculate overall progress
          int overallProgress = 0;
          if (totalGoals > 0) {
            final totalProgressSum = goalsResponse.fold<int>(
              0,
              (sum, goal) => sum + (goal['progress_percentage'] as int? ?? 0),
            );
            overallProgress = (totalProgressSum / totalGoals).round();
          }

          // Check for goals needing attention
          final now = DateTime.now();
          final goalsNeedingAttention = goalsResponse.where((goal) {
            if (goal['status'] == 'completed') return false;

            // Check if deadline is approaching (within 3 days)
            if (goal['deadline'] != null) {
              final deadline = DateTime.parse(goal['deadline']);
              final daysUntilDeadline = deadline.difference(now).inDays;
              if (daysUntilDeadline <= 3 && daysUntilDeadline >= 0) {
                return true;
              }
            }

            // Check if goal was recently updated (needs mentor feedback)
            final updatedAt = DateTime.parse(goal['updated_at']);
            final hoursSinceUpdate = now.difference(updatedAt).inHours;
            if (hoursSinceUpdate <= 48 && goal['progress_percentage'] > 0) {
              // Check if mentor has commented
              return true; // Simplified - you can add comment check
            }

            return false;
          }).length;

          // Get unread messages count
          final conversationResponse = await _supabase
              .from('conversations')
              .select('id')
              .eq('match_id', matchId)
              .maybeSingle();

          int unreadMessages = 0;
          if (conversationResponse != null) {
            final conversationId = conversationResponse['id'] as String;

            final unreadResponse = await _supabase
                .from('messages')
                .select('id')
                .eq('conversation_id', conversationId)
                .eq('sender_id', menteeId)
                .eq('is_read', false);

            unreadMessages = unreadResponse.length;
          }

          // Get last activity (most recent goal update or message)
          DateTime lastActive = DateTime.parse(match['created_at']);

          if (goalsResponse.isNotEmpty) {
            final latestGoalUpdate = DateTime.parse(
              goalsResponse.first['updated_at'],
            );
            if (latestGoalUpdate.isAfter(lastActive)) {
              lastActive = latestGoalUpdate;
            }
          }

          // Determine status
          String status = 'active';
          final daysSinceLastActive = now.difference(lastActive).inDays;
          if (daysSinceLastActive > 7) {
            status = 'inactive';
          }

          // Determine if needs action
          final needsAction = goalsNeedingAttention > 0 || unreadMessages > 0;

          // Determine if on track
          final isOnTrack =
              activeGoals > 0 && overallProgress >= 30 && !needsAction;

          // Create MenteeModel
          final mentee = MenteeModel(
            id: menteeId,
            name:
                profileResponse['full_name'] ??
                profileResponse['username'] ??
                'Unknown',
            avatarUrl: profileResponse['profile_photo_url'],
            status: status,
            overallProgress: overallProgress,
            goalsCompleted: completedGoals,
            totalGoals: totalGoals,
            expertise: profileResponse['expertise'] ?? "Not specified",
            lastActive: lastActive,
            unreadMessages: unreadMessages,
            needsAction: needsAction,
            isOnTrack: isOnTrack,
            matchId: matchId,
          );

          mentees.add(mentee);
        } catch (e) {
          log('Error fetching data for mentee $menteeId: $e');
          continue;
        }
      }

      log('Loaded ${mentees.length} mentees');
      return mentees;
    } catch (e) {
      log('Error fetching mentees: $e');
      rethrow;
    }
  }

  // ============================================================================
  // GET MENTEE RECENT GOALS
  // ============================================================================
  Future<List<Map<String, dynamic>>> getMenteeRecentGoals({
    required String menteeId,
    int limit = 5,
  }) async {
    try {
      final response = await _supabase
          .from('goals')
          .select('*')
          .eq('mentee_id', menteeId)
          .order('updated_at', ascending: false)
          .limit(limit);

      log('✅ Loaded ${response.length} recent goals for mentee $menteeId');

      return response.map<Map<String, dynamic>>((goal) {
        return {
          'id': goal['id'],
          'title': goal['title'],
          'description': goal['description'],
          'mentee_id': goal['mentee_id'],
          'category': goal['category'],
          'status': goal['status'],
          'progress_percentage': goal['progress_percentage'],
          'deadline': goal['deadline'],
          'created_at': goal['created_at'],
          'updated_at': goal['updated_at'],
          'completed_at': goal['completed_at'],
        };
      }).toList();
    } catch (e) {
      log('❌ Error fetching recent goals: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMatchDetails(String matchId) async {
    try {
      final response = await _supabase
          .from('matches')
          .select('*')
          .eq('id', matchId)
          .single();

      log('✅ Loaded match details for $matchId');
      return response;
    } catch (e) {
      log('❌ Error fetching match details: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getGoalFeedback(String goalId) async {
    try {
      // First, get the comments
      final commentsResponse = await _supabase
          .from('goal_comments')
          .select('*')
          .eq('goal_id', goalId)
          .order('created_at', ascending: false);

      if (commentsResponse.isEmpty) {
        log('No feedback found for goal $goalId');
        return [];
      }

      // Then, manually fetch profile details for each comment
      List<Map<String, dynamic>> feedbackList = [];

      for (var comment in commentsResponse) {
        final userId = comment['user_id']; // This is auth user_id

        try {
          // Get profile details using user_id (auth ID)
          final profileResponse = await _supabase
              .from('profiles')
              .select('full_name, username')
              .eq('user_id', userId) // Match on profiles.user_id
              .maybeSingle();

          String mentorName = 'Mentor';
          if (profileResponse != null) {
            mentorName =
                profileResponse['full_name'] ??
                profileResponse['username'] ??
                'Mentor';
          }

          feedbackList.add({
            'comment_text': comment['comment_text'],
            'rating': comment['rating'],
            'created_at': comment['created_at'],
            'mentor_name': mentorName,
          });

          log(
            '✅ Added feedback: ${comment['comment_text'].toString().substring(0, 20)}... by $mentorName',
          );
        } catch (e) {
          log('⚠️ Error fetching profile for user $userId: $e');
          // Still add the comment even if we can't get the profile
          feedbackList.add({
            'comment_text': comment['comment_text'],
            'rating': comment['rating'],
            'created_at': comment['created_at'],
            'mentor_name': 'Mentor',
          });
        }
      }

      log(
        '✅ Fetched ${feedbackList.length} feedback comments for goal $goalId',
      );
      return feedbackList;
    } catch (e) {
      log('❌ Error fetching goal feedback: $e');
      return [];
    }
  }
}
