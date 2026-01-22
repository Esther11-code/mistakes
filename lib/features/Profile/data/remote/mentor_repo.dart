import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

class MentorRepo {
  final supabase = Supabase.instance.client;
  Future<Map<String, int>> getMentorStats(String mentorId) async {
    try {
      final activeMenteesResponse = await supabase
          .from('matches')
          .select('id, responded_at')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted'); 

      final pendingRequestsResponse = await supabase
          .from('matches')
          .select('id')
          .eq('mentor_id', mentorId)
          .eq('status', 'pending');
      final endedResponse = await supabase
          .from('matches')
          .select('id, responded_at, ended_at')
          .eq('mentor_id', mentorId)
          .eq('status', 'ended');
      final declinedResponse = await supabase
          .from('matches')
          .select('id')
          .eq('mentor_id', mentorId)
          .eq('status', 'declined');

      int totalHours = 0;
      for (var match in activeMenteesResponse) {
        if (match['responded_at'] != null) {
          final startDate = DateTime.parse(match['responded_at']);
          final now = DateTime.now();
          final weeks = now.difference(startDate).inDays / 7;
          totalHours += (weeks * 2).toInt(); 
        }
      }

      for (var match in endedResponse) {
        if (match['responded_at'] != null && match['ended_at'] != null) {
          final startDate = DateTime.parse(match['responded_at']);
          final endDate = DateTime.parse(match['ended_at']);
          final weeks = endDate.difference(startDate).inDays / 7;
          totalHours += (weeks * 2).toInt(); 
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

 
  Future<List<Map<String, dynamic>>> getRecentActivities(
    String mentorId,
  ) async {
    try {
      final activities = <Map<String, dynamic>>[];

      final weekAgo = DateTime.now().subtract(Duration(days: 7));

      final newMentorshipsResponse = await supabase
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
          final userResponse = await supabase
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

      final matchesResponse = await supabase
          .from('matches')
          .select('mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted');

      if (matchesResponse.isNotEmpty) {
        final menteeIds = matchesResponse
            .map((m) => m['mentee_id'] as String)
            .toList();

        log('Found ${menteeIds.length} active mentees');

        final goalsResponse = await supabase
            .from('goals')
            .select('*')
            .inFilter('mentee_id', menteeIds)
            .order('updated_at', ascending: false)
            .limit(5);

        for (var goal in goalsResponse) {
          final menteeId = goal['mentee_id'];

          try {
            final userResponse = await supabase
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

      activities.sort(
        (a, b) =>
            (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime),
      );

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
      log('Today is: $now');
      log('Week day: ${now.weekday}');

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

      log('Week range: $startDateStr to $endDateStr');
      final matches = await supabase
          .from('matches')
          .select('mentee_id, id, responded_at')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted');

      log('👥 Active mentees: ${matches.length}');

      if (matches.isEmpty) {
        log('No active mentees found!');
        return;
      }

      final menteeIds = matches.map((m) => m['mentee_id'] as String).toList();
      log('Mentee IDs: $menteeIds');
      final allGoals = await supabase
          .from('goals')
          .select('*')
          .inFilter('mentee_id', menteeIds)
          .order('deadline', ascending: true);

      log('All goals: ${allGoals.length}');

      if (allGoals.isEmpty) {
        log('No goals found at all for these mentees!');
        log('Check if goals have mentee_id set correctly');
        return;
      }
      for (var goal in allGoals) {
        final deadline = goal['deadline'];
        final title = goal['title'];
        final status = goal['status'];
        final menteeId = goal['mentee_id'];

        log('Goal: $title');
        log('Mentee ID: $menteeId');
        log('Deadline: $deadline (${deadline.runtimeType})');
        log('Status: $status');
        log('Progress: ${goal['progress_percentage']}%');

        if (deadline != null) {
          final isInRange =
              deadline.compareTo(startDateStr) >= 0 &&
              deadline.compareTo(endDateStr) <= 0;
          log('   In range? $isInRange');

          if (deadline == startDateStr || deadline == endDateStr) {
            log('EXACT MATCH WITH RANGE BOUNDARIES!');
          }
        }
      }
      log('Testing actual query with filter');
      final filteredGoals = await supabase
          .from('goals')
          .select('*')
          .inFilter('mentee_id', menteeIds)
          .gte('deadline', startDateStr)
          .lte('deadline', endDateStr)
          .order('deadline', ascending: true);

      log('Filtered query returned: ${filteredGoals.length} goals');
    } catch (e) {
      log('error: $e');
    }
  }
  Future<List<Map<String, dynamic>>> getThisWeeksTasks(String mentorId) async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(Duration(days: 6));

      final tasks = <Map<String, dynamic>>[];
      final pendingRequestsResponse = await supabase
          .from('matches')
          .select('id, created_at, mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'pending')
          .order('created_at', ascending: true);

      for (var request in pendingRequestsResponse) {
        final menteeId = request['mentee_id'];

        try {
          final userResponse = await supabase
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
      final matchesResponse = await supabase
          .from('matches')
          .select('mentee_id, id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted');

      // final menteeToMatchMap = {
      //   for (var m in matchesResponse)
      //     m['mentee_id'] as String: m['id'] as String,
      // };
      if (matchesResponse.isNotEmpty) {
        final menteeIds = matchesResponse
            .map((m) => m['mentee_id'] as String)
            .toList();
        final threeDaysAgo = now.subtract(Duration(days: 3));

        final goalsWithProgressResponse = await supabase
            .from('goals')
            .select('*')
            .inFilter('mentee_id', menteeIds)
            .gte('updated_at', threeDaysAgo.toIso8601String())
            .order('updated_at', ascending: false);

        for (var goal in goalsWithProgressResponse) {
          final menteeId = goal['mentee_id'];
          final goalId = goal['id'];
          final commentsResponse = await supabase
              .from('goal_comments')
              .select('id')
              .eq('goal_id', goalId)
              .eq('user_id', mentorId)
              .limit(1);
          if (commentsResponse.isEmpty && goal['progress_percentage'] > 0) {
            try {
              final userResponse = await supabase
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
                ), 
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
        final startDateStr =
            '${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}';
        final endDateStr =
            '${endOfWeek.year}-${endOfWeek.month.toString().padLeft(2, '0')}-${endOfWeek.day.toString().padLeft(2, '0')}';

        log(
          'Searching for goals with deadline between $startDateStr and $endDateStr',
        );

        final goalsResponse = await supabase
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
            final userResponse = await supabase
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
      tasks.sort((a, b) {
        if (a['type'] == 'pending_request' && b['type'] != 'pending_request') {
          return -1;
        }
        if (b['type'] == 'pending_request' && a['type'] != 'pending_request') {
          return 1;
        }
        if (a['type'] == 'comment_needed' && b['type'] == 'goal_deadline') {
          return -1;
        }
        if (b['type'] == 'comment_needed' && a['type'] == 'goal_deadline') {
          return 1;
        }
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
  Future<List<Map<String, dynamic>>> getActiveMentees(String mentorId) async {
    try {
      final response = await supabase
          .from('matches')
          .select('id, created_at, mentee_id')
          .eq('mentor_id', mentorId)
          .eq('status', 'accepted')
          .order('created_at', ascending: false);

      final mentees = <Map<String, dynamic>>[];

      for (var match in response) {
        final menteeId = match['mentee_id'];

        try {
          final userResponse = await supabase
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

  Future<Map<String, dynamic>> getMenteeDetails(String menteeId) async {
    try {
      final response = await supabase
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
  Future<List<Map<String, dynamic>>> getIncomingRequestsWithDetails(
    String mentorId,
  ) async {
    try {
      final response = await supabase
          .from('matches')
          .select(
            'id, message, goals, status, created_at, mentee_id',
          ) 
          .eq('mentor_id', mentorId)
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      log('Found ${response.length} pending requests');

      final requests = <Map<String, dynamic>>[];

      for (var request in response) {
        final menteeId = request['mentee_id'];

        try {
          final userResponse = await supabase
              .from('profiles')
              .select(
                'user_id, username, full_name, profile_photo_url, bio, expertise, area_of_interest',
              )
              .eq('user_id', menteeId)
              .single();

          requests.add({
            'match_id': request['id'],
            'message': request['message'] ?? 'No message provided',
            'goals': request['goals'] ?? [],
            'status': request['status'],
            'created_at': request['created_at'],
            'area_of_interest': userResponse['area_of_interest'],
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
  Future<void> acceptRequest(String matchId, {String? welcomeMessage}) async {
    try {
      final updateData = {
        'status': 'accepted',
        'responded_at': DateTime.now().toIso8601String(),
      };
      if (welcomeMessage != null && welcomeMessage.isNotEmpty) {
        updateData['welcome_message'] = welcomeMessage;
      }

      await supabase.from('matches').update(updateData).eq('id', matchId);

      log('Request accepted: $matchId');
    } catch (e) {
      log('Error accepting request: $e');
      rethrow;
    }
  }

  Future<void> declineRequest(String matchId) async {
    try {
      await supabase
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
      final profileResponse = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      final profileId = profileResponse['id'];

      final response = await supabase
          .from('mentor_settings')
          .select(
            'accepting_requests, max_active_mentees, auto_reply_enabled, auto_reply_message, notify_new_requests, notify_mentee_messages, notify_goal_completions',
          )
          .eq('mentor_id', profileId)
          .maybeSingle();
      if (response == null) {
        await supabase.from('mentor_settings').insert({
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
      final profileResponse = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      final profileId = profileResponse['id'];

      await supabase
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
      final profileResponse = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      final profileId = profileResponse['id'];

      await supabase
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
      final profileResponse = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      final profileId = profileResponse['id'];

      await supabase
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
      final profileResponse = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', mentorId)
          .single();

      final profileId = profileResponse['id'];
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

      await supabase
          .from('mentor_settings')
          .update({columnName: enabled})
          .eq('mentor_id', profileId);

      log('Updated $columnName to $enabled');
    } catch (e) {
      log('Error updating notification setting: $e');
      rethrow;
    }
  }

  Future<String> getMentorName(String mentorId) async {
    try {
      final response = await supabase
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
  Future<void> saveAchievementForMentee(
    String menteeId,
    String achievementType, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await supabase.from('user_achievements').insert({
        'user_id': menteeId,
        'achievement_type': achievementType,
        'metadata': metadata,
      });

      log('Achievement saved for mentee $menteeId: $achievementType');
    } catch (e) {
      log('Error saving achievement: $e');
    }
  }

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
        return null; 
      }
      final match = await supabase
          .from('matches')
          .select('mentor_id, welcome_message, responded_at')
          .eq('mentee_id', menteeId)
          .eq('status', 'accepted')
          .maybeSingle();

      if (match == null) return null;
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
  Future<Map<String, dynamic>?> getMenteeMentorDetails(String menteeId) async {
    try {
      final matchResponse = await supabase
          .from('matches')
          .select('id, mentor_id, requested_at, responded_at, welcome_message')
          .eq('mentee_id', menteeId)
          .eq('status', 'accepted')
          .maybeSingle();
      if (matchResponse == null) {
        log('No active mentor found for mentee $menteeId');
        return null;
      }

      final mentorId = matchResponse['mentor_id'];
      final mentorProfileResponse = await supabase
          .from('profiles')
          .select(
            'id, user_id, username, full_name, profile_photo_url, bio, expertise, years_experience, linkedin_url, availability, is_verified',
          )
          .eq('user_id', mentorId)
          .single();

      final skillsResponse = await supabase
          .from('user_skills')
          .select('skill_name, proficiency_level')
          .eq('user_id', mentorId);

      final conversationResponse = await supabase
          .from('conversations')
          .select('id')
          .eq('mentor_id', mentorId)
          .eq('mentee_id', menteeId)
          .maybeSingle();

      final goalsResponse = await supabase
          .from('goals')
          .select('id, status')
          .eq('mentee_id', menteeId)
          .eq('match_id', matchResponse['id']);

      final totalGoals = goalsResponse.length;
      final completedGoals = goalsResponse
          .where((g) => g['status'] == 'completed')
          .length;

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

  Future<List<Map<String, dynamic>>> getAllMenteeMentorships(
    String menteeId,
  ) async {
    try {
      final matchesResponse = await supabase
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
          final mentorResponse = await supabase
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

  Future<bool> hasActiveMentor(String menteeId) async {
    try {
      final response = await supabase
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

  Future<void> endMentorship(String matchId, String reason) async {
    try {
      await supabase
          .from('matches')
          .update({
            'status': 'ended',
            'ended_at': DateTime.now().toIso8601String(),
            'end_reason': reason, 
          })
          .eq('id', matchId);

      log('Mentorship ended: $matchId');
    } catch (e) {
      log('Error ending mentorship: $e');
      rethrow;
    }
  }
}
