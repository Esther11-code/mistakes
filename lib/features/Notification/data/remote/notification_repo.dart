import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepo {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    try {
      final profileResponse = await supabase
          .from('profiles')
          .select('id, role')
          .eq('user_id', userId)
          .single();

      final profileId = profileResponse['id'];
      final role = profileResponse['role'] as String;

      final notifications = <Map<String, dynamic>>[];

      if (role.toLowerCase() == 'mentor') {
        final settingsResponse = await supabase
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
        await fetchMenteeNotifications(userId, notifications);
      }

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
  Future<void> _fetchMentorNotifications(
    String userId,
    List<Map<String, dynamic>> notifications, {
    required bool notifyNewRequests,
    required bool notifyMessages,
    required bool notifyGoalCompletions,
  }) async {
    if (notifyNewRequests) {
      final requestsResponse = await supabase
          .from('matches')
          .select('id, requested_at, mentee_id')
          .eq('mentor_id', userId)
          .eq('status', 'pending')
          .order('requested_at', ascending: false)
          .limit(10);

      for (var request in requestsResponse) {
        try {
          final menteeResponse = await supabase
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

    if (notifyMessages) {
      final conversationsResponse = await supabase
          .from('conversations')
          .select('id, mentee_id, last_message, last_message_at, last_message_sender_id')
          .eq('mentor_id', userId)
          .not('last_message', 'is', null)
          .neq('last_message_sender_id', userId) 
          .order('last_message_at', ascending: false)
          .limit(10);

      for (var conv in conversationsResponse) {
        try {
          final menteeResponse = await supabase
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

    if (notifyGoalCompletions) {
      final matchesResponse = await supabase
          .from('matches')
          .select('mentee_id')
          .eq('mentor_id', userId)
          .eq('status', 'accepted');

      if (matchesResponse.isNotEmpty) {
        final menteeIds = matchesResponse.map((m) => m['mentee_id'] as String).toList();

        final goalsResponse = await supabase
            .from('goals')
            .select('id, title, completed_at, mentee_id')
            .inFilter('mentee_id', menteeIds)
            .eq('status', 'completed')
            .not('completed_at', 'is', null)
            .order('completed_at', ascending: false)
            .limit(10);

        for (var goal in goalsResponse) {
          try {
            final menteeResponse = await supabase
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
  Future<void> fetchMenteeNotifications(
    String userId,
    List<Map<String, dynamic>> notifications,
  ) async {
    final matchesResponse = await supabase
        .from('matches')
        .select('id, status, responded_at, mentor_id')
        .eq('mentee_id', userId)
        .inFilter('status', ['accepted', 'declined'])
        .not('responded_at', 'is', null)
        .order('responded_at', ascending: false)
        .limit(10);

    for (var match in matchesResponse) {
      try {
        final mentorResponse = await supabase
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
    final conversationsResponse = await supabase
        .from('conversations')
        .select('id, mentor_id, last_message, last_message_at, last_message_sender_id')
        .eq('mentee_id', userId)
        .not('last_message', 'is', null)
        .neq('last_message_sender_id', userId)
        .order('last_message_at', ascending: false)
        .limit(10);

    for (var conv in conversationsResponse) {
      try {
        final mentorResponse = await supabase
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

    final goalsResponse = await supabase
        .from('goals')
        .select('id, title')
        .eq('mentee_id', userId);

    if (goalsResponse.isNotEmpty) {
      final goalIds = goalsResponse.map((g) => g['id'] as String).toList();

      final commentsResponse = await supabase
          .from('goal_comments')
          .select('id, comment_text, created_at, user_id, goal_id')
          .inFilter('goal_id', goalIds)
          .neq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(10);

      for (var comment in commentsResponse) {
        try {
          final commenterResponse = await supabase
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