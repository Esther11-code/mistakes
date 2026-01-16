// lib/features/Profile/data/remote/mentor_repo.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

class MentorRepo {
  final _supabase = Supabase.instance.client;

  // ============================================================================
  // MENTOR STATS
  // ============================================================================
  Future<Map<String, int>> getMentorStats(String mentorId) async {
    try {
      // Active mentees count - using 'matches' table and 'accepted' status
      final activeMenteesResponse = await _supabase
          .from('matches')
          .select('id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted'); // Correct enum value

      // Pending requests count
      final pendingRequestsResponse = await _supabase
          .from('matches')
          .select('id')
          .eq('mentor_id', mentorId)
          .eq('status', 'pending');

      // Ended mentorships
      final endedResponse = await _supabase
          .from('matches')
          .select('id')
          .eq('mentor_id', mentorId)
          .eq('status', 'ended');

      // Declined requests
      final declinedResponse = await _supabase
          .from('matches')
          .select('id')
          .eq('mentor_id', mentorId)
          .eq('status', 'declined');

      log(
        'Stats: Active=${activeMenteesResponse.length}, Pending=${pendingRequestsResponse.length}, Ended=${endedResponse.length}, Declined=${declinedResponse.length}',
      );

      return {
        'activeMentees': activeMenteesResponse.length,
        'pendingRequests': pendingRequestsResponse.length,
        'endedMentorships': endedResponse.length,
        'declinedRequests': declinedResponse.length,
        'totalHours': 0,
      };
    } catch (e) {
      log(' Error fetching mentor stats: $e');
      rethrow;
    }
  }

  // ============================================================================
  // RECENT ACTIVITIES
  // ============================================================================
  Future<List<Map<String, dynamic>>> getRecentActivities(
    String mentorId,
  ) async {
    try {
      final matchesResponse = await _supabase
          .from('matches')
          .select('mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted');

      if (matchesResponse.isEmpty) {
        log(' No active mentees found');
        return [];
      }

      final menteeIds = matchesResponse
          .map((m) => m['mentee_id'] as String)
          .toList();

      log('🔵 Found ${menteeIds.length} active mentees');

      final goalsResponse = await _supabase
          .from('goals')
          .select('*')
          .inFilter('mentee_id', menteeIds)
          .order('updated_at', ascending: false)
          .limit(5);

      final activities = <Map<String, dynamic>>[];

      for (var goal in goalsResponse) {
        final menteeId = goal['mentee_id'];

        try {
          // Get user from profiles table
          final userResponse = await _supabase
              .from('profiles')
              .select('full_name, profile_photo_url')
              .eq('user_id', menteeId)
              .single();

          activities.add({
            'id': goal['id'],
            'type': 'goal_updated',
            'title': goal['title'],
            'description': goal['description'],
            'status': goal['status'],
            'timestamp': DateTime.parse(goal['updated_at']),
            'mentee_name': userResponse['full_name'] ?? 'Unknown',
            'mentee_avatar': userResponse['profile_photo_url'],
            'icon': _getIconForGoalType(goal['category']),
          });
        } catch (e) {
          log(' Could not fetch profile for mentee $menteeId: $e');
          continue;
        }
      }

      log('Loaded ${activities.length} recent activities');
      return activities;
    } catch (e) {
      log(' Error fetching recent activities: $e');
      return [];
    }
  }

  String _getIconForGoalType(String? category) {
    switch (category) {
      case 'career':
        return 'work';
      case 'skill':
        return 'code';
      case 'personal':
        return 'person';
      default:
        return 'trophy';
    }
  }

  // ============================================================================
  // THIS WEEK'S TASKS
  // ============================================================================
  Future<List<Map<String, dynamic>>> getThisWeeksTasks(String mentorId) async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(Duration(days: 6));

      final matchesResponse = await _supabase
          .from('matches')
          .select('mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted');

      if (matchesResponse.isEmpty) {
        return [];
      }

      final menteeIds = matchesResponse
          .map((m) => m['mentee_id'] as String)
          .toList();

      final goalsResponse = await _supabase
          .from('goals')
          .select('*')
          .inFilter('mentee_id', menteeIds)
          .gte('deadline', startOfWeek.toIso8601String())
          .lte('deadline', endOfWeek.toIso8601String())
          .order('deadline', ascending: true)
          .limit(10);

      final tasks = <Map<String, dynamic>>[];

      for (var goal in goalsResponse) {
        final menteeId = goal['mentee_id'];

        try {
          final userResponse = await _supabase
              .from('profiles')
              .select('full_name')
              .eq('user_id', menteeId)
              .single();

          tasks.add({
            'id': goal['id'],
            'title': goal['title'],
            'deadline': DateTime.parse(goal['deadline']),
            'status': goal['status'],
            'priority': _determinePriority(DateTime.parse(goal['deadline'])),
            'mentee_name': userResponse['full_name'] ?? 'Unknown',
            'is_completed': goal['status'] == 'completed',
          });
        } catch (e) {
          log(' Could not fetch profile for mentee $menteeId: $e');
          continue;
        }
      }

      log('Loaded ${tasks.length} tasks for this week');
      return tasks;
    } catch (e) {
      log(' Error fetching this week\'s tasks: $e');
      return [];
    }
  }

  String _determinePriority(DateTime deadline) {
    final now = DateTime.now();
    final daysUntil = deadline.difference(now).inDays;

    if (daysUntil <= 1) return 'high';
    if (daysUntil <= 3) return 'medium';
    return 'low';
  }

  // ============================================================================
  // FETCH ACTIVE MENTEES
  // ============================================================================
  Future<List<Map<String, dynamic>>> getActiveMentees(String mentorId) async {
    try {
      final response = await _supabase
          .from('matches')
          .select('id, created_at, mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted')
          .order('created_at', ascending: false);

      final mentees = <Map<String, dynamic>>[];

      for (var match in response) {
        final menteeId = match['mentee_id'];

        try {
          final userResponse = await _supabase
              .from('profiles')
              .select(
                'user_id, username, full_name, profile_photo_url, bio, expertise, location',
              )
              .eq('user_id', menteeId)
              .single();

          mentees.add({
            'match_id': match['id'],
            'created_at': match['created_at'],
            'mentee': userResponse,
          });
        } catch (e) {
          log(' Could not fetch profile for mentee $menteeId: $e');
          continue;
        }
      }

      log('Loaded ${mentees.length} active mentees');
      return mentees;
    } catch (e) {
      log(' Error fetching active mentees: $e');
      rethrow;
    }
  }

  // ============================================================================
  // FETCH MENTEE DETAILS
  // ============================================================================
  Future<Map<String, dynamic>> getMenteeDetails(String menteeId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select(
            'user_id, username, full_name, profile_photo_url, bio, expertise, years_experience, location, created_at',
          )
          .eq('user_id', menteeId)
          .single();

      return response;
    } catch (e) {
      log(' Error fetching mentee details: $e');
      rethrow;
    }
  }

  // ============================================================================
  // FETCH INCOMING REQUESTS
  // ============================================================================
  Future<List<Map<String, dynamic>>> getIncomingRequestsWithDetails(
    String mentorId,
  ) async {
    try {
      final response = await _supabase
          .from('matches')
          .select(
            'id, message, goals, status, created_at, mentee_id',
          ) // message and goals exist
          .eq('mentor_id', mentorId)
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      log('🔍 Found ${response.length} pending requests');

      final requests = <Map<String, dynamic>>[];

      for (var request in response) {
        final menteeId = request['mentee_id'];

        try {
          final userResponse = await _supabase
              .from('profiles')
              .select(
                'user_id, username, full_name, profile_photo_url, bio, expertise',
              )
              .eq('user_id', menteeId)
              .single();

          requests.add({
            'match_id': request['id'],
            'message': request['message'] ?? 'No message provided',
            'goals': request['goals'] ?? [],
            'status': request['status'],
            'created_at': request['created_at'],
            'mentee': userResponse,
          });
        } catch (e) {
          log(' Could not fetch profile for mentee $menteeId: $e');
          continue;
        }
      }

      log('Loaded ${requests.length} incoming requests with details');
      return requests;
    } catch (e) {
      log(' Error fetching incoming requests: $e');
      rethrow;
    }
  }

  // ============================================================================
  // ACCEPT/DECLINE REQUEST
  // ============================================================================
  Future<void> acceptRequest(String matchId) async {
    try {
      await _supabase
          .from('matches')
          .update({
            'status': 'accepted',
            'responded_at': DateTime.now().toIso8601String(),
          })
          .eq('id', matchId);

      log('Request accepted: $matchId');
    } catch (e) {
      log(' Error accepting request: $e');
      rethrow;
    }
  }

  Future<void> declineRequest(String matchId) async {
    try {
      await _supabase
          .from('matches')
          .update({
            'status': 'declined',
            'responded_at': DateTime.now().toIso8601String(),
          })
          .eq('id', matchId);

      log('Request declined: $matchId');
    } catch (e) {
      log(' Error declining request: $e');
      rethrow;
    }
  }
}
