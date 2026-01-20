// lib/features/Notification/data/notification_repository.dart

import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepo {
  final _supabase = Supabase.instance.client;

  // ============================================================================
  // FETCH NOTIFICATIONS FOR USER (MENTOR OR MENTEE)
  // ============================================================================
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    try {
      // Get the profile to check role
      final profileResponse = await _supabase
          .from('profiles')
          .select('id, role')
          .eq('user_id', userId)
          .single();

      final profileId = profileResponse['id'];
      final role = profileResponse['role'] as String;

      final notifications = <Map<String, dynamic>>[];

      if (role.toLowerCase() == 'mentor') {
        // Get mentor's notification settings using profile ID
        final settingsResponse = await _supabase
            .from('mentor_settings')
            .select(
              'notify_new_requests, notify_mentee_messages, notify_goal_completions',
            )
            .eq('mentor_id', profileId)
            .maybeSingle();

        final notifyNewRequests = settingsResponse?['notify_new_requests'] ?? true;
        final notifyMessages = settingsResponse?['notify_mentee_messages'] ?? true;
        final notifyGoalCompletions = settingsResponse?['notify_goal_completions'] ?? true;

        await _fetchMentorNotifications(
          userId,
          notifications,
          notifyNewRequests: notifyNewRequests,
          notifyMessages: notifyMessages,
          notifyGoalCompletions: notifyGoalCompletions,
        );
      } else {
        // Fetch mentee notifications
        await _fetchMenteeNotifications(userId, notifications);
      }

      // Sort by timestamp (most recent first)
      notifications.sort(
        (a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime),
      );

      log('Loaded ${notifications.length} notifications');
      return notifications;
    } catch (e) {
      log('Error fetching notifications: $e');
      rethrow;
    }
  }

  // ============================================================================
  // FETCH MENTOR NOTIFICATIONS
  // ============================================================================
  Future<void> _fetchMentorNotifications(
    String userId,
    List<Map<String, dynamic>> notifications, {
    required bool notifyNewRequests,
    required bool notifyMessages,
    required bool notifyGoalCompletions,
  }) async {
    // 1. NEW MENTORSHIP REQUESTS (if enabled)
    if (notifyNewRequests) {
      final requestsResponse = await _supabase
          .from('matches')
          .select('id, requested_at, mentee_id')
          .eq('mentor_id', userId)
          .eq('status', 'pending')
          .order('requested_at', ascending: false)
          .limit(10);

      for (var request in requestsResponse) {
        try {
          final menteeResponse = await _supabase
              .from('profiles')
              .select('full_name, profile_photo_url')
              .eq('user_id', request['mentee_id'])
              .single();

          notifications.add({
            'id': 'request_${request['id']}',
            'type': 'new_request',
            'title': 'New Mentorship Request',
            'message': '${menteeResponse['full_name']} wants to be your mentee',
            'avatar': menteeResponse['profile_photo_url'],
            'timestamp': DateTime.parse(request['requested_at']),
            'is_read': false,
            'action_id': request['id'],
          });
        } catch (e) {
          log('Error fetching mentee details: $e');
        }
      }
    }

    // 2. MENTEE MESSAGES (if enabled)
    if (notifyMessages) {
      // Get conversations where current user is the mentor
      final conversationsResponse = await _supabase
          .from('conversations')
          .select('id, mentee_id, last_message, last_message_at, last_message_sender_id')
          .eq('mentor_id', userId)
          .not('last_message', 'is', null)
          .neq('last_message_sender_id', userId) // Only messages from mentee
          .order('last_message_at', ascending: false)
          .limit(10);

      for (var conv in conversationsResponse) {
        try {
          final menteeResponse = await _supabase
              .from('profiles')
              .select('full_name, profile_photo_url')
              .eq('user_id', conv['mentee_id'])
              .single();

          notifications.add({
            'id': 'message_${conv['id']}',
            'type': 'new_message',
            'title': 'New Message',
            'message': '${menteeResponse['full_name']}: ${conv['last_message']}',
            'avatar': menteeResponse['profile_photo_url'],
            'timestamp': DateTime.parse(conv['last_message_at']),
            'is_read': false,
            'action_id': conv['id'],
          });
        } catch (e) {
          log('Error fetching mentee details: $e');
        }
      }
    }

    // 3. GOAL COMPLETIONS (if enabled)
    if (notifyGoalCompletions) {
      // Get active mentees
      final matchesResponse = await _supabase
          .from('matches')
          .select('mentee_id')
          .eq('mentor_id', userId)
          .eq('status', 'accepted');

      if (matchesResponse.isNotEmpty) {
        final menteeIds = matchesResponse.map((m) => m['mentee_id'] as String).toList();

        final goalsResponse = await _supabase
            .from('goals')
            .select('id, title, completed_at, mentee_id')
            .inFilter('mentee_id', menteeIds)
            .eq('status', 'completed')
            .not('completed_at', 'is', null)
            .order('completed_at', ascending: false)
            .limit(10);

        for (var goal in goalsResponse) {
          try {
            final menteeResponse = await _supabase
                .from('profiles')
                .select('full_name, profile_photo_url')
                .eq('user_id', goal['mentee_id'])
                .single();

            notifications.add({
              'id': 'goal_${goal['id']}',
              'type': 'goal_completed',
              'title': 'Goal Completed',
              'message': '${menteeResponse['full_name']} completed "${goal['title']}"',
              'avatar': menteeResponse['profile_photo_url'],
              'timestamp': DateTime.parse(goal['completed_at']),
              'is_read': false,
              'action_id': goal['id'],
            });
          } catch (e) {
            log('Error fetching mentee details: $e');
          }
        }
      }
    }
  }

  // ============================================================================
  // FETCH MENTEE NOTIFICATIONS
  // ============================================================================
  Future<void> _fetchMenteeNotifications(
    String userId,
    List<Map<String, dynamic>> notifications,
  ) async {
    // 1. MATCH STATUS UPDATES
    final matchesResponse = await _supabase
        .from('matches')
        .select('id, status, responded_at, mentor_id')
        .eq('mentee_id', userId)
        .inFilter('status', ['accepted', 'declined'])
        .not('responded_at', 'is', null)
        .order('responded_at', ascending: false)
        .limit(10);

    for (var match in matchesResponse) {
      try {
        final mentorResponse = await _supabase
            .from('profiles')
            .select('full_name, profile_photo_url')
            .eq('user_id', match['mentor_id'])
            .single();

        if (match['status'] == 'accepted') {
          notifications.add({
            'id': 'match_accepted_${match['id']}',
            'type': 'match_accepted',
            'title': 'Request Accepted',
            'message': '${mentorResponse['full_name']} accepted your mentorship request!',
            'avatar': mentorResponse['profile_photo_url'],
            'timestamp': DateTime.parse(match['responded_at']),
            'is_read': false,
            'action_id': match['id'],
          });
        } else if (match['status'] == 'declined') {
          notifications.add({
            'id': 'match_declined_${match['id']}',
            'type': 'match_declined',
            'title': 'Request Declined',
            'message': '${mentorResponse['full_name']} declined your request',
            'avatar': mentorResponse['profile_photo_url'],
            'timestamp': DateTime.parse(match['responded_at']),
            'is_read': false,
            'action_id': match['id'],
          });
        }
      } catch (e) {
        log('Error fetching mentor details: $e');
      }
    }

    // 2. MENTOR MESSAGES
    final conversationsResponse = await _supabase
        .from('conversations')
        .select('id, mentor_id, last_message, last_message_at, last_message_sender_id')
        .eq('mentee_id', userId)
        .not('last_message', 'is', null)
        .neq('last_message_sender_id', userId) // Only messages from mentor
        .order('last_message_at', ascending: false)
        .limit(10);

    for (var conv in conversationsResponse) {
      try {
        final mentorResponse = await _supabase
            .from('profiles')
            .select('full_name, profile_photo_url')
            .eq('user_id', conv['mentor_id'])
            .single();

        notifications.add({
          'id': 'message_${conv['id']}',
          'type': 'new_message',
          'title': 'New Message',
          'message': '${mentorResponse['full_name']}: ${conv['last_message']}',
          'avatar': mentorResponse['profile_photo_url'],
          'timestamp': DateTime.parse(conv['last_message_at']),
          'is_read': false,
          'action_id': conv['id'],
        });
      } catch (e) {
        log('Error fetching mentor details: $e');
      }
    }

    // 3. GOAL COMMENTS FROM MENTOR
    final goalsResponse = await _supabase
        .from('goals')
        .select('id, title')
        .eq('mentee_id', userId);

    if (goalsResponse.isNotEmpty) {
      final goalIds = goalsResponse.map((g) => g['id'] as String).toList();

      final commentsResponse = await _supabase
          .from('goal_comments')
          .select('id, comment_text, created_at, user_id, goal_id')
          .inFilter('goal_id', goalIds)
          .neq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(10);

      for (var comment in commentsResponse) {
        try {
          final commenterResponse = await _supabase
              .from('profiles')
              .select('full_name, profile_photo_url')
              .eq('user_id', comment['user_id'])
              .single();

          final goal = goalsResponse.firstWhere((g) => g['id'] == comment['goal_id']);

          notifications.add({
            'id': 'comment_${comment['id']}',
            'type': 'goal_comment',
            'title': 'New Comment',
            'message': '${commenterResponse['full_name']} commented on "${goal['title']}"',
            'avatar': commenterResponse['profile_photo_url'],
            'timestamp': DateTime.parse(comment['created_at']),
            'is_read': false,
            'action_id': comment['goal_id'],
          });
        } catch (e) {
          log('Error fetching commenter details: $e');
        }
      }
    }
  }
}