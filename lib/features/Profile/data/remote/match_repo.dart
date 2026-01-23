import 'dart:developer';
import 'package:mistakes/main.dart';

class MatchesRepo {
  Future<void> sendMentorshipRequest({
    required String menteeId,
    required String mentorId,
    required String message,
    required List<String> goals,
  }) async {
    try {
      log('Sending mentorship request');

      final activeMentorship = await supabase
          .from('matches')
          .select()
          .eq('mentee_id', menteeId)
          .eq('status', 'accepted')
          .maybeSingle();

      if (activeMentorship != null) {
        throw Exception(
          'You already have an active mentor. You can only have one mentor at a time.',
        );
      }
      final existing = await supabase
          .from('matches')
          .select()
          .eq('mentee_id', menteeId)
          .eq('mentor_id', mentorId)
          .maybeSingle();

      if (existing != null) {
        throw Exception('Request already sent to this mentor');
      }

      await supabase.from('matches').insert({
        'mentor_id': mentorId,
        'mentee_id': menteeId,
        'status': 'pending',
        'message': message,
        'goals': goals,
        'requested_at': DateTime.now().toIso8601String(),
      });

      log(' Request sent successfully');
    } catch (e) {
      log('  Error sending request: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMyPendingRequests(
    String menteeId,
  ) async {
    try {
      log('Loading pending requests for mentee: $menteeId');

      final response = await supabase
          .from('matches')
          .select('''
            id,
            mentor_id,
            mentee_id,
            status,
            message,
            goals,
            requested_at
          ''')
          .eq('mentee_id', menteeId)
          .eq('status', 'pending')
          .order('requested_at', ascending: false);

      final requests = <Map<String, dynamic>>[];
      for (var match in response) {
        final mentorProfile = await supabase
            .from('profiles')
            .select('*')
            .eq('user_id', match['mentor_id'])
            .single();

        requests.add({
          'match_id': match['id'],
          'mentor_id': match['mentor_id'],
          'mentor_name': mentorProfile['full_name'],
          'mentor_username': mentorProfile['username'],
          'mentor_expertise': mentorProfile['expertise'],
          'mentor_photo': mentorProfile['profile_photo_url'],
          'message': match['message'],
          'goals': match['goals'] != null
              ? List<String>.from(match['goals'])
              : <String>[],
          'requested_at': match['requested_at'],
        });
      }

      log(' Found ${requests.length} pending requests');
      return requests;
    } catch (e) {
      log('  Error loading requests: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getIncomingRequests(
    String mentorId,
  ) async {
    try {
      log('Loading incoming requests for mentor: $mentorId');

      final response = await supabase
          .from('matches')
          .select('''
            id,
            mentor_id,
            mentee_id,
            status,
            message,
            goals,
            requested_at
          ''')
          .eq('mentor_id', mentorId)
          .eq('status', 'pending')
          .order('requested_at', ascending: false);

      final requests = <Map<String, dynamic>>[];
      for (var match in response) {
        final menteeProfile = await supabase
            .from('profiles')
            .select('*')
            .eq('user_id', match['mentee_id'])
            .single();

        final menteeInterests = menteeProfile['area_of_interest'] != null
            ? List<String>.from(menteeProfile['area_of_interest'])
            : <String>[];

        requests.add({
          'match_id': match['id'],
          'mentee_id': match['mentee_id'],
          'mentee_name': menteeProfile['full_name'],
          'mentee_username': menteeProfile['username'],
          'mentee_bio': menteeProfile['bio'],
          'mentee_photo': menteeProfile['profile_photo_url'],
          'mentee_interests': menteeInterests,
          'message': match['message'],
          'goals': match['goals'] != null
              ? List<String>.from(match['goals'])
              : <String>[],
          'requested_at': match['requested_at'],
        });
      }

      log(' Found ${requests.length} incoming requests');
      return requests;
    } catch (e) {
      log('  Error loading incoming requests: $e');
      rethrow;
    }
  }

  Future<void> acceptRequest(String matchId) async {
    try {
      log('Accepting request: $matchId');

      await supabase
          .from('matches')
          .update({
            'status': 'accepted',
            'responded_at': DateTime.now().toIso8601String(),
          })
          .eq('id', matchId);

      log(' Request accepted');
    } catch (e) {
      log(' Error accepting request: $e');
      rethrow;
    }
  }

  Future<void> declineRequest(String matchId) async {
    try {
      log('Declining request: $matchId');

      await supabase
          .from('matches')
          .update({
            'status': 'declined',
            'responded_at': DateTime.now().toIso8601String(),
          })
          .eq('id', matchId);

      log(' Request declined');
    } catch (e) {
      log('  Error declining request: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getActiveMentorships({
    required String userId,
    required bool isMentor,
  }) async {
    try {
      log('Loading active mentorships for: $userId (mentor: $isMentor)');

      final query = supabase
          .from('matches')
          .select('''
            id,
            mentor_id,
            mentee_id,
            status,
            requested_at,
            responded_at
          ''')
          .eq('status', 'accepted');

      final response = isMentor
          ? await query.eq('mentor_id', userId)
          : await query.eq('mentee_id', userId);
      final mentorships = <Map<String, dynamic>>[];
      for (var match in response) {
        final partnerId = isMentor ? match['mentee_id'] : match['mentor_id'];

        final partnerProfile = await supabase
            .from('profiles')
            .select('*')
            .eq('user_id', partnerId)
            .single();

        final interests = partnerProfile['area_of_interest'] != null
            ? List<String>.from(partnerProfile['area_of_interest'])
            : <String>[];

        mentorships.add({
          'match_id': match['id'],
          'partner_id': partnerId,
          'partner_name': partnerProfile['full_name'],
          'partner_username': partnerProfile['username'],
          'partner_bio': partnerProfile['bio'],
          'partner_photo': partnerProfile['profile_photo_url'],
          'partner_role': partnerProfile['role'],
          'partner_interests': interests,
          'partner_expertise': partnerProfile['expertise'],
          'started_at': match['responded_at'],
        });
      }

      log(' Found ${mentorships.length} active mentorships');
      return mentorships;
    } catch (e) {
      log('  Error loading mentorships: $e');
      rethrow;
    }
  }

  Future<String?> checkMatchStatus({
    required String menteeId,
    required String mentorId,
  }) async {
    try {
      final response = await supabase
          .from('matches')
          .select('status')
          .eq('mentee_id', menteeId)
          .eq('mentor_id', mentorId)
          .maybeSingle();

      return response?['status'];
    } catch (e) {
      log('  Error checking match status: $e');
      return null;
    }
  }

  Future<void> endMentorship(String matchId) async {
    try {
      log('Ending mentorship: $matchId');

      await supabase
          .from('matches')
          .update({
            'status': 'ended',
            'ended_at': DateTime.now().toIso8601String(),
          })
          .eq('id', matchId);

      log(' Mentorship ended');
    } catch (e) {
      log('  Error ending mentorship: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMyRequestsByStatus({
    required String menteeId,
    String? status,
  }) async {
    try {
      log('Loading requests for mentee: $menteeId, status: $status');

      var query = supabase
          .from('matches')
          .select('''
          id,
          mentor_id,
          mentee_id,
          status,
          message,
          goals,
          requested_at,
          responded_at
        ''')
          .eq('mentee_id', menteeId);

      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query.order('requested_at', ascending: false);

      final requests = <Map<String, dynamic>>[];
      for (var match in response) {
        final mentorProfile = await supabase
            .from('profiles')
            .select('*')
            .eq('user_id', match['mentor_id'])
            .single();

        requests.add({
          'match_id': match['id'],
          'mentor_id': match['mentor_id'],
          'mentor_name': mentorProfile['full_name'],
          'mentor_username': mentorProfile['username'],
          'mentor_expertise': mentorProfile['expertise'],
          'mentor_photo': mentorProfile['profile_photo_url'],
          'status': match['status'],
          'message': match['message'],
          'goals': match['goals'] != null
              ? List<String>.from(match['goals'])
              : <String>[],
          'requested_at': match['requested_at'],
          'responded_at': match['responded_at'],
        });
      }

      log(' Found ${requests.length} requests');
      return requests;
    } catch (e) {
      log('  Error loading requests: $e');
      rethrow;
    }
  }
}
