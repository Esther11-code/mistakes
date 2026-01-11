import 'dart:developer';
import 'package:mistakes/features/Dashboard/data/local/model/mentor_model.dart';


class DashboardRepo {
  // TODO: Add Supabase client

  Future<List<MenteeModel>> getMentees({required String mentorId}) async {
    try {
      log('Fetching mentees for mentor: $mentorId');
      
      // TODO: Replace with actual Supabase query
      // final response = await supabase
      //     .from('matches')
      //     .select('''
      //       *,
      //       mentee:profiles!mentee_id (
      //         id,
      //         full_name,
      //         profile_photo_url
      //       ),
      //       goals:goals (
      //         id,
      //         status,
      //         progress_percentage
      //       ),
      //       messages:messages (
      //         id,
      //         is_read
      //       )
      //     ''')
      //     .eq('mentor_id', mentorId)
      //     .eq('status', 'accepted');
      
      // Process data and calculate progress, unread messages, etc.
      
      // Dummy data for testing
      await Future.delayed(Duration(seconds: 1));
      return [
        MenteeModel(
          id: '1',
          name: 'Sarah Johnson',
          avatarUrl: null,
          status: 'active',
          overallProgress: 75,
          goalsCompleted: 3,
          totalGoals: 5,
          unreadMessages: 2,
          lastActive: DateTime.now().subtract(Duration(days: 2)),
          matchId: 'match_1',
        ),
        MenteeModel(
          id: '2',
          name: 'Michael Chen',
          avatarUrl: null,
          status: 'active',
          overallProgress: 40,
          goalsCompleted: 1,
          totalGoals: 4,
          unreadMessages: 5,
          lastActive: DateTime.now().subtract(Duration(days: 10)),
          matchId: 'match_2',
        ),
        MenteeModel(
          id: '3',
          name: 'Emma Davis',
          avatarUrl: null,
          status: 'active',
          overallProgress: 90,
          goalsCompleted: 4,
          totalGoals: 4,
          unreadMessages: 0,
          lastActive: DateTime.now().subtract(Duration(hours: 5)),
          matchId: 'match_3',
        ),
      ];
    } catch (e) {
      log('Error in getMentees: $e');
      throw Exception('Failed to load mentees: $e');
    }
  }
}