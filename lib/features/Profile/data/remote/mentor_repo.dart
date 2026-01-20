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
          .select('id, responded_at')
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
          .select('id, responded_at, ended_at')
          .eq('mentor_id', mentorId)
          .eq('status', 'ended');

      // Declined requests
      final declinedResponse = await _supabase
          .from('matches')
          .select('id')
          .eq('mentor_id', mentorId)
          .eq('status', 'declined');

      int totalHours = 0;
      // Active mentorships - estimate based on duration (assume 2 hours/week average)
      for (var match in activeMenteesResponse) {
        if (match['responded_at'] != null) {
          final startDate = DateTime.parse(match['responded_at']);
          final now = DateTime.now();
          final weeks = now.difference(startDate).inDays / 7;
          totalHours += (weeks * 2).toInt(); // 2 hours per week estimate
        }
      }

      // Ended mentorships - calculate actual duration
      for (var match in endedResponse) {
        if (match['responded_at'] != null && match['ended_at'] != null) {
          final startDate = DateTime.parse(match['responded_at']);
          final endDate = DateTime.parse(match['ended_at']);
          final weeks = endDate.difference(startDate).inDays / 7;
          totalHours += (weeks * 2).toInt(); // 2 hours per week estimate
        }
      }

      log('Total hours: $totalHours');
      log(
        'Stats: Active=${activeMenteesResponse.length}, Pending=${pendingRequestsResponse.length}, Ended=${endedResponse.length}, Declined=${declinedResponse.length}',
      );

      return {
        'activeMentees': activeMenteesResponse.length,
        'pendingRequests': pendingRequestsResponse.length,
        'endedMentorships': endedResponse.length,
        'declinedRequests': declinedResponse.length,
        'totalHours': totalHours,
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

  // Add this to MentorRepo to see what's really happening

  Future<void> debugThisWeeksTasks(String mentorId) async {
    try {
      final now = DateTime.now();
      log('📅 Today is: $now');
      log('📅 Week day: ${now.weekday}');

      // Calculate week range
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day - now.weekday + 1,
      );
      final endOfWeek = startOfWeek.add(
        Duration(days: 6, hours: 23, minutes: 59),
      );

      final startDateStr =
          '${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}';
      final endDateStr =
          '${endOfWeek.year}-${endOfWeek.month.toString().padLeft(2, '0')}-${endOfWeek.day.toString().padLeft(2, '0')}';

      log('📅 Week range: $startDateStr to $endDateStr');

      // Get all active mentees
      final matches = await _supabase
          .from('matches')
          .select('mentee_id, id, responded_at')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted');

      log('👥 Active mentees: ${matches.length}');

      if (matches.isEmpty) {
        log('⚠️ No active mentees found!');
        return;
      }

      final menteeIds = matches.map((m) => m['mentee_id'] as String).toList();
      log('📋 Mentee IDs: $menteeIds');

      // Get ALL goals for these mentees (no filters)
      final allGoals = await _supabase
          .from('goals')
          .select('*')
          .inFilter('mentee_id', menteeIds)
          .order('deadline', ascending: true);

      log('📊 TOTAL GOALS FOUND: ${allGoals.length}');

      if (allGoals.isEmpty) {
        log('⚠️ No goals found at all for these mentees!');
        log('⚠️ Check if goals have mentee_id set correctly');
        return;
      }

      // Analyze each goal
      for (var goal in allGoals) {
        final deadline = goal['deadline'];
        final title = goal['title'];
        final status = goal['status'];
        final menteeId = goal['mentee_id'];

        log('─────────────────────────────────');
        log('📌 Goal: $title');
        log('   Mentee ID: $menteeId');
        log('   Deadline: $deadline (${deadline.runtimeType})');
        log('   Status: $status');
        log('   Progress: ${goal['progress_percentage']}%');

        // Check if this deadline is in range
        if (deadline != null) {
          final isInRange =
              deadline.compareTo(startDateStr) >= 0 &&
              deadline.compareTo(endDateStr) <= 0;
          log('   In range? $isInRange');

          if (deadline == startDateStr || deadline == endDateStr) {
            log('   🎯 EXACT MATCH WITH RANGE BOUNDARIES!');
          }
        }
      }

      log('─────────────────────────────────');

      // Try the actual query
      log('🔍 Testing actual query with filters...');
      final filteredGoals = await _supabase
          .from('goals')
          .select('*')
          .inFilter('mentee_id', menteeIds)
          .gte('deadline', startDateStr)
          .lte('deadline', endDateStr)
          .order('deadline', ascending: true);

      log('✅ Filtered query returned: ${filteredGoals.length} goals');
    } catch (e) {
      log('❌ Debug error: $e');
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
          .select('mentee_id, id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted');

      final menteeToMatchMap = {
        for (var m in matchesResponse)
          m['mentee_id'] as String: m['id'] as String,
      };
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

        final startDateStr =
            '${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}';
        final endDateStr =
            '${endOfWeek.year}-${endOfWeek.month.toString().padLeft(2, '0')}-${endOfWeek.day.toString().padLeft(2, '0')}';

        log(
          'Searching for goals with deadline between $startDateStr and $endDateStr',
        );

        final goalsResponse = await _supabase
            .from('goals')
            .select('*')
            .inFilter('mentee_id', menteeIds)
            .gte('deadline', startOfWeek.toIso8601String())
            .lte('deadline', endOfWeek.toIso8601String())
            .order('deadline', ascending: true);

        log('Found ${goalsResponse.length} goals with deadlines this week');

        for (var goal in goalsResponse) {
          final menteeId = goal['mentee_id'];

          try {
            final userResponse = await _supabase
                .from('profiles')
                .select('full_name')
                .eq('user_id', menteeId)
                .single();
            final deadline = DateTime.parse(goal['deadline']);
            tasks.add({
              'id': goal['id'],
              'type': 'goal_deadline',
              'title': goal['title'],
              'deadline': deadline,
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
          'auto_reply_message':
              'Thank you for your interest! I am currently at capacity and unable to accept new mentees at this time.',
          'notify_new_requests': true,
          'notify_mentee_messages': true,
          'notify_goal_completions': true,
        });

        // Return default values
        return {
          'accepting_requests': true,
          'max_active_mentees': 5,
          'auto_reply_enabled': false,
          'auto_reply_message':
              'Thank you for your interest! I am currently at capacity and unable to accept new mentees at this time.',
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

  // Add these methods to your MentorRepo class

  // ============================================================================
  // GET MENTOR NAME
  // ============================================================================
  Future<String> getMentorName(String mentorId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('user_id', mentorId)
          .single();

      return response['full_name'] ?? 'Your mentor';
    } catch (e) {
      log('Error fetching mentor name: $e');
      return 'Your mentor';
    }
  }

  // ============================================================================
  // SAVE ACHIEVEMENT FOR USER (Mentee)
  // ============================================================================
  Future<void> saveAchievementForMentee(
    String menteeId,
    String achievementType, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabase.from('user_achievements').insert({
        'user_id': menteeId,
        'achievement_type': achievementType,
        'metadata': metadata,
      });

      log('✅ Achievement saved for mentee $menteeId: $achievementType');
    } catch (e) {
      log('❌ Error saving achievement: $e');
      // Don't throw - achievements are non-critical
    }
  }

  // ============================================================================
  // CHECK PENDING MENTORSHIP ACHIEVEMENT FOR MENTEE
  // ============================================================================
  Future<Map<String, dynamic>?> checkPendingMentorshipAchievement(
    String menteeId,
  ) async {
    try {
      // Check if achievement already exists
      final existingAchievement = await _supabase
          .from('user_achievements')
          .select('id')
          .eq('user_id', menteeId)
          .eq('achievement_type', 'first_mentorship_started')
          .maybeSingle();

      if (existingAchievement != null) {
        return null; // Already shown
      }

      // Check if they have an accepted mentorship
      final match = await _supabase
          .from('matches')
          .select('mentor_id, welcome_message, responded_at')
          .eq('mentee_id', menteeId)
          .eq('status', 'accepted')
          .maybeSingle();

      if (match == null) return null;

      // Get mentor name
      final mentorProfile = await _supabase
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

  // ============================================================================
  // GET MENTEE'S MENTOR DETAILS
  // ============================================================================
  Future<Map<String, dynamic>?> getMenteeMentorDetails(String menteeId) async {
    try {
      // First, get the active mentorship match
      final matchResponse = await _supabase
          .from('matches')
          .select('id, mentor_id, requested_at, responded_at, welcome_message')
          .eq('mentee_id', menteeId)
          .eq('status', 'accepted')
          .maybeSingle();

      // If no active mentor, return null
      if (matchResponse == null) {
        log('No active mentor found for mentee $menteeId');
        return null;
      }

      final mentorId = matchResponse['mentor_id'];

      // Get mentor's profile details
      final mentorProfileResponse = await _supabase
          .from('profiles')
          .select(
            'id, user_id, username, full_name, profile_photo_url, bio, expertise, years_experience, linkedin_url, availability, is_verified',
          )
          .eq('user_id', mentorId)
          .single();

      // Get mentor's skills
      final skillsResponse = await _supabase
          .from('user_skills')
          .select('skill_name, proficiency_level')
          .eq('user_id', mentorId);

      // Get the conversation ID for this mentorship
      final conversationResponse = await _supabase
          .from('conversations')
          .select('id')
          .eq('mentor_id', mentorId)
          .eq('mentee_id', menteeId)
          .maybeSingle();

      // Get total goals count for this mentorship
      final goalsResponse = await _supabase
          .from('goals')
          .select('id, status')
          .eq('mentee_id', menteeId)
          .eq('match_id', matchResponse['id']);

      final totalGoals = goalsResponse.length;
      final completedGoals = goalsResponse
          .where((g) => g['status'] == 'completed')
          .length;

      // Combine all data
      final mentorDetails = {
        'match_id': matchResponse['id'],
        'mentor_id': mentorId,
        'mentor_profile_id': mentorProfileResponse['id'],
        'username': mentorProfileResponse['username'],
        'full_name': mentorProfileResponse['full_name'],
        'profile_photo_url': mentorProfileResponse['profile_photo_url'],
        'bio': mentorProfileResponse['bio'],
        'expertise': mentorProfileResponse['expertise'],
        'years_experience': mentorProfileResponse['years_experience'],
        'linkedin_url': mentorProfileResponse['linkedin_url'],
        'availability': mentorProfileResponse['availability'],
        'is_verified': mentorProfileResponse['is_verified'],
        'skills': skillsResponse,
        'mentorship_started_at': matchResponse['responded_at'],
        'welcome_message': matchResponse['welcome_message'],
        'conversation_id': conversationResponse?['id'],
        'total_goals': totalGoals,
        'completed_goals': completedGoals,
      };

      log('Loaded mentor details for mentee $menteeId');
      return mentorDetails;
    } catch (e) {
      log('Error fetching mentee\'s mentor details: $e');
      rethrow;
    }
  }

  // ============================================================================
  // GET ALL MENTORS FOR A MENTEE (including past/declined)
  // ============================================================================
  Future<List<Map<String, dynamic>>> getAllMenteeMentorships(
    String menteeId,
  ) async {
    try {
      final matchesResponse = await _supabase
          .from('matches')
          .select(
            'id, mentor_id, status, requested_at, responded_at, ended_at, message, goals',
          )
          .eq('mentee_id', menteeId)
          .order('requested_at', ascending: false);

      final mentorships = <Map<String, dynamic>>[];

      for (var match in matchesResponse) {
        final mentorId = match['mentor_id'];

        try {
          final mentorResponse = await _supabase
              .from('profiles')
              .select(
                'user_id, username, full_name, profile_photo_url, bio, expertise, years_experience',
              )
              .eq('user_id', mentorId)
              .single();

          mentorships.add({
            'match_id': match['id'],
            'status': match['status'],
            'requested_at': match['requested_at'],
            'responded_at': match['responded_at'],
            'ended_at': match['ended_at'],
            'message': match['message'],
            'goals': match['goals'],
            'mentor': mentorResponse,
          });
        } catch (e) {
          log('Could not fetch profile for mentor $mentorId: $e');
          continue;
        }
      }

      log('Loaded ${mentorships.length} mentorships for mentee $menteeId');
      return mentorships;
    } catch (e) {
      log('Error fetching mentee mentorships: $e');
      rethrow;
    }
  }

  // ============================================================================
  // CHECK IF MENTEE HAS ACTIVE MENTOR
  // ============================================================================
  Future<bool> hasActiveMentor(String menteeId) async {
    try {
      final response = await _supabase
          .from('matches')
          .select('id')
          .eq('mentee_id', menteeId)
          .eq('status', 'accepted')
          .maybeSingle();

      return response != null;
    } catch (e) {
      log('Error checking active mentor: $e');
      return false;
    }
  }

  // ============================================================================
  // END MENTORSHIP
  // ============================================================================
  Future<void> endMentorship(String matchId, String reason) async {
    try {
      await _supabase
          .from('matches')
          .update({
            'status': 'ended',
            'ended_at': DateTime.now().toIso8601String(),
            'end_reason': reason, // You might need to add this column
          })
          .eq('id', matchId);

      log('✅ Mentorship ended: $matchId');
    } catch (e) {
      log('❌ Error ending mentorship: $e');
      rethrow;
    }
  }
}
