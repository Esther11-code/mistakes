import 'dart:developer';
import 'package:mistakes/main.dart';

class MatchesRepo {
  /// Send mentorship request
/// Send mentorship request
Future<void> sendMentorshipRequest({
  required String menteeId,
  required String mentorId,
  required String message,
  required List<String> goals,
}) async {
  try {
    log('🔵 [MatchesRepo] Sending mentorship request');

    // ⭐ Check if mentee already has an active mentor
    final activeMentorship = await supabase
        .from('matches')
        .select()
        .eq('mentee_id', menteeId)
        .eq('status', 'accepted')
        .maybeSingle();

    if (activeMentorship != null) {
      throw Exception('You already have an active mentor. You can only have one mentor at a time.');
    }

    // Check if request already exists to this specific mentor
    final existing = await supabase
        .from('matches')
        .select()
        .eq('mentee_id', menteeId)
        .eq('mentor_id', mentorId)
        .maybeSingle();

    if (existing != null) {
      throw Exception('Request already sent to this mentor');
    }

    // Create new request
    await supabase.from('matches').insert({
      'mentor_id': mentorId,
      'mentee_id': menteeId,
      'status': 'pending',
      'message': message,
      'goals': goals,
      'requested_at': DateTime.now().toIso8601String(),
    });

    log('✅ [MatchesRepo] Request sent successfully');
  } catch (e) {
    log('❌ [MatchesRepo] Error sending request: $e');
    rethrow;
  }
}
  /// Get pending requests sent by mentee
  Future<List<Map<String, dynamic>>> getMyPendingRequests(String menteeId) async {
    try {
      log('🔵 [MatchesRepo] Loading pending requests for mentee: $menteeId');

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

      // Get mentor details for each request
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
          'goals': match['goals'] != null ? List<String>.from(match['goals']) : <String>[],
          'requested_at': match['requested_at'],
        });
      }

      log('✅ [MatchesRepo] Found ${requests.length} pending requests');
      return requests;
    } catch (e) {
      log('❌ [MatchesRepo] Error loading requests: $e');
      rethrow;
    }
  }

  /// Get incoming requests for mentor
  Future<List<Map<String, dynamic>>> getIncomingRequests(String mentorId) async {
    try {
      log('🔵 [MatchesRepo] Loading incoming requests for mentor: $mentorId');

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

      // Get mentee details
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
          'goals': match['goals'] != null ? List<String>.from(match['goals']) : <String>[],
          'requested_at': match['requested_at'],
        });
      }

      log('✅ [MatchesRepo] Found ${requests.length} incoming requests');
      return requests;
    } catch (e) {
      log('❌ [MatchesRepo] Error loading incoming requests: $e');
      rethrow;
    }
  }

  /// Accept mentorship request
  Future<void> acceptRequest(String matchId) async {
    try {
      log('🔵 [MatchesRepo] Accepting request: $matchId');

      await supabase.from('matches').update({
        'status': 'accepted',
        'responded_at': DateTime.now().toIso8601String(),
      }).eq('id', matchId);

      log('✅ [MatchesRepo] Request accepted');
    } catch (e) {
      log('❌ [MatchesRepo] Error accepting request: $e');
      rethrow;
    }
  }

  /// Decline mentorship request
  Future<void> declineRequest(String matchId) async {
    try {
      log('🔵 [MatchesRepo] Declining request: $matchId');

      await supabase.from('matches').update({
        'status': 'declined',
        'responded_at': DateTime.now().toIso8601String(),
      }).eq('id', matchId);

      log('✅ [MatchesRepo] Request declined');
    } catch (e) {
      log('❌ [MatchesRepo] Error declining request: $e');
      rethrow;
    }
  }

  /// Get active mentorships
  Future<List<Map<String, dynamic>>> getActiveMentorships({
    required String userId,
    required bool isMentor,
  }) async {
    try {
      log('🔵 [MatchesRepo] Loading active mentorships for: $userId (mentor: $isMentor)');

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

      // Get partner details
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

      log('✅ [MatchesRepo] Found ${mentorships.length} active mentorships');
      return mentorships;
    } catch (e) {
      log('❌ [MatchesRepo] Error loading mentorships: $e');
      rethrow;
    }
  }

  /// Check match status
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
      log('❌ [MatchesRepo] Error checking match status: $e');
      return null;
    }
  }

  /// End mentorship
  Future<void> endMentorship(String matchId) async {
    try {
      log('🔵 [MatchesRepo] Ending mentorship: $matchId');

      await supabase.from('matches').update({
        'status': 'ended',
        'ended_at': DateTime.now().toIso8601String(),
      }).eq('id', matchId);

      log('✅ [MatchesRepo] Mentorship ended');
    } catch (e) {
      log('❌ [MatchesRepo] Error ending mentorship: $e');
      rethrow;
    }
  }

  /// Get mentee's requests by status (for filtering)
Future<List<Map<String, dynamic>>> getMyRequestsByStatus({
  required String menteeId,
  String? status, // null = all, 'pending', 'accepted', 'declined'
}) async {
  try {
    log('🔵 [MatchesRepo] Loading requests for mentee: $menteeId, status: $status');

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

    // Add status filter if provided
    if (status != null) {
      query = query.eq('status', status);
    }

    final response = await query.order('requested_at', ascending: false);

    // Get mentor details for each request
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
        'goals': match['goals'] != null ? List<String>.from(match['goals']) : <String>[],
        'requested_at': match['requested_at'],
        'responded_at': match['responded_at'],
      });
    }

    log('✅ [MatchesRepo] Found ${requests.length} requests');
    return requests;
  } catch (e) {
    log('❌ [MatchesRepo] Error loading requests: $e');
    rethrow;
  }
}


}