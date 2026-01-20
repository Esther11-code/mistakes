// lib/features/Profile/data/remote/mentor_repo.dart
import 'package:flutter/material.dart';
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
  // ============================================================================// In mentor_repo.dart, update getRecentActivities:

  Future<List<Map<String, dynamic>>> getRecentActivities(
    String mentorId,
  ) async {
    try {
      final activities = <Map<String, dynamic>>[];

      // ========================================
      // 1. Get recently started mentorships (last 7 days)
      // ========================================
      final weekAgo = DateTime.now().subtract(Duration(days: 7));

      final newMentorshipsResponse = await _supabase
          .from('matches')
          .select('id, created_at, responded_at, mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted')
          .gte('responded_at', weekAgo.toIso8601String())
          .order('responded_at', ascending: false)
          .limit(3);

      for (var match in newMentorshipsResponse) {
        final menteeId = match['mentee_id'];

        try {
          final userResponse = await _supabase
              .from('profiles')
              .select('full_name, profile_photo_url')
              .eq('user_id', menteeId)
              .single();

          activities.add({
            'id': match['id'],
            'type': 'mentorship_started',
            'title': 'New Mentorship Started',
            'description':
                'You accepted ${userResponse['full_name']} as your mentee',
            'status': 'active',
            'timestamp': DateTime.parse(match['responded_at']),
            'mentee_name': userResponse['full_name'] ?? 'Unknown',
            'mentee_avatar': userResponse['profile_photo_url'],
            'icon': _getIconFromString('handshake'),
          });
        } catch (e) {
          log('Could not fetch profile for mentee $menteeId: $e');
          continue;
        }
      }

      // ========================================
      // 2. Get active mentees' goal updates
      // ========================================
      final matchesResponse = await _supabase
          .from('matches')
          .select('mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted');

      if (matchesResponse.isNotEmpty) {
        final menteeIds = matchesResponse
            .map((m) => m['mentee_id'] as String)
            .toList();

        log('Found ${menteeIds.length} active mentees');

        final goalsResponse = await _supabase
            .from('goals')
            .select('*')
            .inFilter('mentee_id', menteeIds)
            .order('updated_at', ascending: false)
            .limit(5);

        for (var goal in goalsResponse) {
          final menteeId = goal['mentee_id'];

          try {
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
            log('Could not fetch profile for mentee $menteeId: $e');
            continue;
          }
        }
      }

      // Sort all activities by timestamp (most recent first)
      activities.sort(
        (a, b) =>
            (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime),
      );

      // Return top 5 activities
      final topActivities = activities.take(5).toList();

      log('Loaded ${topActivities.length} recent activities');
      return topActivities;
    } catch (e) {
      log('Error fetching recent activities: $e');
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

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'handshake':
        return Icons.handshake_rounded;
      case 'work':
        return Icons.work_outline;
      case 'code':
        return Icons.code;
      case 'person':
        return Icons.person_outline;
      case 'trophy':
      default:
        return Icons.emoji_events;
    }
  }
  // ============================================================================
  // THIS WEEK'S TASKS
  // ============================================================================
  // In mentor_repo.dart, update getThisWeeksTasks:

  Future<List<Map<String, dynamic>>> getThisWeeksTasks(String mentorId) async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(Duration(days: 6));

      final tasks = <Map<String, dynamic>>[];

      // ========================================
      // 1. Pending mentorship requests to review
      // ========================================
      final pendingRequestsResponse = await _supabase
          .from('matches')
          .select('id, created_at, mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'pending')
          .order('created_at', ascending: true);

      for (var request in pendingRequestsResponse) {
        final menteeId = request['mentee_id'];

        try {
          final userResponse = await _supabase
              .from('profiles')
              .select('full_name')
              .eq('user_id', menteeId)
              .single();

          final createdAt = DateTime.parse(request['created_at']);
          final daysWaiting = now.difference(createdAt).inDays;

          tasks.add({
            'id': request['id'],
            'type': 'pending_request',
            'title': 'Review mentorship request',
            'deadline': createdAt.add(Duration(days: 3)),
            'status': 'pending',
            'priority': daysWaiting >= 2 ? 'high' : 'medium',
            'mentee_name': userResponse['full_name'] ?? 'Unknown',
            'is_completed': false,
            'days_waiting': daysWaiting,
          });
        } catch (e) {
          log('Could not fetch profile for mentee $menteeId: $e');
          continue;
        }
      }

      // ========================================
      // 2. Goals with recent progress updates (need comments)
      // ========================================
      final matchesResponse = await _supabase
          .from('matches')
          .select('mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted');

      if (matchesResponse.isNotEmpty) {
        final menteeIds = matchesResponse
            .map((m) => m['mentee_id'] as String)
            .toList();

        // Get goals updated in the last 3 days without mentor comments
        final threeDaysAgo = now.subtract(Duration(days: 3));

        final goalsWithProgressResponse = await _supabase
            .from('goals')
            .select('*')
            .inFilter('mentee_id', menteeIds)
            .gte('updated_at', threeDaysAgo.toIso8601String())
            .order('updated_at', ascending: false);

        for (var goal in goalsWithProgressResponse) {
          final menteeId = goal['mentee_id'];
          final goalId = goal['id'];

          // Check if mentor has commented on this goal
          final commentsResponse = await _supabase
              .from('goal_comments')
              .select('id')
              .eq('goal_id', goalId)
              .eq('user_id', mentorId)
              .limit(1);

          // If no comments from mentor and progress > 0, add to tasks
          if (commentsResponse.isEmpty && goal['progress_percentage'] > 0) {
            try {
              final userResponse = await _supabase
                  .from('profiles')
                  .select('full_name')
                  .eq('user_id', menteeId)
                  .single();

              final updatedAt = DateTime.parse(goal['updated_at']);
              final hoursAgo = now.difference(updatedAt).inHours;

              tasks.add({
                'id': goal['id'],
                'type': 'comment_needed',
                'title': 'Comment on "${goal['title']}"',
                'deadline': updatedAt.add(
                  Duration(days: 2),
                ), // Suggest commenting within 2 days
                'status': 'active',
                'priority': hoursAgo >= 48 ? 'high' : 'medium',
                'mentee_name': userResponse['full_name'] ?? 'Unknown',
                'is_completed': false,
                'progress_percentage': goal['progress_percentage'],
              });
            } catch (e) {
              log('Could not fetch profile for mentee $menteeId: $e');
              continue;
            }
          }
        }

        // ========================================
        // 3. Goals with deadlines this week
        // ========================================
        final goalsResponse = await _supabase
            .from('goals')
            .select('*')
            .inFilter('mentee_id', menteeIds)
            .gte('deadline', startOfWeek.toIso8601String())
            .lte('deadline', endOfWeek.toIso8601String())
            .order('deadline', ascending: true);

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
              'type': 'goal_deadline',
              'title': goal['title'],
              'deadline': DateTime.parse(goal['deadline']),
              'status': goal['status'],
              'priority': _determinePriority(DateTime.parse(goal['deadline'])),
              'mentee_name': userResponse['full_name'] ?? 'Unknown',
              'is_completed': goal['status'] == 'completed',
            });
          } catch (e) {
            log('Could not fetch profile for mentee $menteeId: $e');
            continue;
          }
        }
      }

      // Sort tasks: pending requests first, then comments needed, then by deadline
      tasks.sort((a, b) {
        // Pending requests first
        if (a['type'] == 'pending_request' && b['type'] != 'pending_request') {
          return -1;
        }
        if (b['type'] == 'pending_request' && a['type'] != 'pending_request') {
          return 1;
        }

        // Comment needed second
        if (a['type'] == 'comment_needed' && b['type'] == 'goal_deadline') {
          return -1;
        }
        if (b['type'] == 'comment_needed' && a['type'] == 'goal_deadline') {
          return 1;
        }

        // Then by deadline/priority
        return (a['deadline'] as DateTime).compareTo(b['deadline'] as DateTime);
      });

      log('Loaded ${tasks.length} tasks for this week');
      return tasks.take(10).toList();
    } catch (e) {
      log('Error fetching this week\'s tasks: $e');
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
                'user_id, username, full_name, profile_photo_url, bio, expertise',
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
            'user_id, username, full_name, profile_photo_url, bio, expertise, years_experience, created_at, learning_goals, area_of_interest, availability, linkedin_url',
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
  Future<void> acceptRequest(String matchId, {String? welcomeMessage}) async {
    try {
      final updateData = {
        'status': 'accepted',
        'responded_at': DateTime.now().toIso8601String(),
      };

      // Add welcome message if provided
      if (welcomeMessage != null && welcomeMessage.isNotEmpty) {
        updateData['welcome_message'] = welcomeMessage;
      }

      await _supabase.from('matches').update(updateData).eq('id', matchId);

      log('Request accepted: $matchId');
    } catch (e) {
      log('Error accepting request: $e');
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


Future<Map<String, dynamic>> getMentorSettings(String mentorId) async {
  try {
    // First, get the profile ID from user_id
    final profileResponse = await _supabase
        .from('profiles')
        .select('id')
        .eq('user_id', mentorId)
        .single();

    final profileId = profileResponse['id'];

    final response = await _supabase
        .from('mentor_settings')
        .select(
          'accepting_requests, max_active_mentees, auto_reply_enabled, auto_reply_message, notify_new_requests, notify_mentee_messages, notify_goal_completions',
        )
        .eq('mentor_id', profileId)
        .maybeSingle();

    // If no settings exist yet, create default settings
    if (response == null) {
      await _supabase.from('mentor_settings').insert({
        'mentor_id': profileId,
        'accepting_requests': true,
        'max_active_mentees': 5,
        'auto_reply_enabled': false,
        'auto_reply_message': 'Thank you for your interest! I am currently at capacity and unable to accept new mentees at this time.',
        'notify_new_requests': true,
        'notify_mentee_messages': true,
        'notify_goal_completions': true,
      });

      // Return default values
      return {
        'accepting_requests': true,
        'max_active_mentees': 5,
        'auto_reply_enabled': false,
        'auto_reply_message': 'Thank you for your interest! I am currently at capacity and unable to accept new mentees at this time.',
        'notify_new_requests': true,
        'notify_mentee_messages': true,
        'notify_goal_completions': true,
      };
    }

    log('Loaded mentor settings: $response');
    return response;
  } catch (e) {
    log('Error fetching mentor settings: $e');
    rethrow;
  }
}

Future<void> updateAcceptingNewRequests(
  String mentorId,
  bool accepting,
) async {
  try {
    // Get profile ID first
    final profileResponse = await _supabase
        .from('profiles')
        .select('id')
        .eq('user_id', mentorId)
        .single();

    final profileId = profileResponse['id'];

    await _supabase
        .from('mentor_settings')
        .update({'accepting_requests': accepting})
        .eq('mentor_id', profileId);

    log('Updated accepting_requests to $accepting');
  } catch (e) {
    log('Error updating accepting_requests: $e');
    rethrow;
  }
}

Future<void> updateMaxActiveMentees(String mentorId, int maxMentees) async {
  try {
    // Get profile ID first
    final profileResponse = await _supabase
        .from('profiles')
        .select('id')
        .eq('user_id', mentorId)
        .single();

    final profileId = profileResponse['id'];

    await _supabase
        .from('mentor_settings')
        .update({'max_active_mentees': maxMentees})
        .eq('mentor_id', profileId);

    log('Updated max_active_mentees to $maxMentees');
  } catch (e) {
    log('Error updating max_active_mentees: $e');
    rethrow;
  }
}

Future<void> updateAutoReply(String mentorId, bool autoReply) async {
  try {
    // Get profile ID first
    final profileResponse = await _supabase
        .from('profiles')
        .select('id')
        .eq('user_id', mentorId)
        .single();

    final profileId = profileResponse['id'];

    await _supabase
        .from('mentor_settings')
        .update({'auto_reply_enabled': autoReply})
        .eq('mentor_id', profileId);

    log('Updated auto_reply_enabled to $autoReply');
  } catch (e) {
    log('Error updating auto_reply: $e');
    rethrow;
  }
}

Future<void> updateNotificationSetting(
  String mentorId,
  String notificationType,
  bool enabled,
) async {
  try {
    // Get profile ID first
    final profileResponse = await _supabase
        .from('profiles')
        .select('id')
        .eq('user_id', mentorId)
        .single();

    final profileId = profileResponse['id'];

    // Map the notification type to the correct column name
    String columnName;
    switch (notificationType) {
      case 'new_requests':
        columnName = 'notify_new_requests';
        break;
      case 'messages':
        columnName = 'notify_mentee_messages';
        break;
      case 'goal_completions':
        columnName = 'notify_goal_completions';
        break;
      default:
        columnName = 'notify_$notificationType';
    }

    await _supabase
        .from('mentor_settings')
        .update({columnName: enabled})
        .eq('mentor_id', profileId);

    log('Updated $columnName to $enabled');
  } catch (e) {
    log('Error updating notification setting: $e');
    rethrow;
  }
}
}
