import 'dart:developer';
import 'package:mistakes/features/Goal/data/model/goal_model.dart';
import 'package:mistakes/features/Goal/data/model/interest_model.dart';
import 'package:mistakes/main.dart';

class GoalRepo {
  Future<List<GoalModel>> getGoals({required String menteeId}) async {
    try {
      log('Fetching goals for mentee: $menteeId');
      
      final response = await supabase
          .from('goals')
          .select()
          .eq('mentee_id', menteeId)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => GoalModel.fromJson(json))
          .toList();
    } catch (e) {
      log('Error in getGoals: $e');
      throw Exception('Failed to load goals: $e');
    }
  }

  Future<void> updateGoalProgress({
    required String goalId,
    required int progressPercentage,
  }) async {
    try {
      log('Updating goal $goalId progress to $progressPercentage%');
      
      await supabase
          .from('goals')
          .update({
            'progress_percentage': progressPercentage,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', goalId);
      
      log('Goal progress updated successfully');
    } catch (e) {
      log('Error in updateGoalProgress: $e');
      throw Exception('Failed to update goal progress: $e');
    }
  }

  Future<void> createGoal({
    required String menteeId,
    String? matchId,
    required String title,
    required String description,
    required String category,
    DateTime? deadline,
  }) async {
    try {
      log('Creating new goal for mentee: $menteeId');
      
      await supabase.from('goals').insert({
        'mentee_id': menteeId,
        'match_id': matchId,
        'title': title,
        'description': description,
        'category': category,
        'progress_percentage': 0,
        'status': 'active',
        'deadline': deadline?.toIso8601String(),
      });
      
      log('Goal created successfully');
    } catch (e) {
      log('Error in createGoal: $e');
      throw Exception('Failed to create goal: $e');
    }
  }

  Future<void> deleteGoal({required String goalId}) async {
    try {
      log('Deleting goal: $goalId');
      
      await supabase
          .from('goals')
          .delete()
          .eq('id', goalId);
      
      log('Goal deleted successfully');
    } catch (e) {
      log('Error in deleteGoal: $e');
      throw Exception('Failed to delete goal: $e');
    }
  }

    // ============================================================================
  // FETCH ALL INTERESTS FROM DATABASE
  // ============================================================================
  Future<List<InterestModel>> getAllInterests() async {
    try {
      log('🔵 Fetching all interests from database');
      
      final response = await supabase
          .from('interests')
          .select('*')
          .order('name', ascending: true);
      
      final interests = (response as List)
          .map((json) => InterestModel.fromJson(json))
          .toList();
      
      log('✅ Loaded ${interests.length} interests');
      return interests;
    } catch (e) {
      log('❌ Error fetching interests: $e');
      throw Exception('Failed to load interests: ${e.toString()}');
    }
  }

  // ============================================================================
  // FETCH INTERESTS BY TYPE
  // ============================================================================
  Future<List<InterestModel>> getInterestsByType(String type) async {
    try {
      log('🔵 Fetching $type interests');
      
      final response = await supabase
          .from('interests')
          .select('*')
          .eq('type', type)
          .order('name', ascending: true);
      
      final interests = (response as List)
          .map((json) => InterestModel.fromJson(json))
          .toList();
      
      log('✅ Loaded ${interests.length} $type interests');
      return interests;
    } catch (e) {
      log('❌ Error fetching $type interests: $e');
      throw Exception('Failed to load interests: ${e.toString()}');
    }
  }

  // ============================================================================
  // FETCH INTERESTS GROUPED BY TYPE
  // ============================================================================
  Future<Map<String, List<InterestModel>>> getInterestsGroupedByType() async {
    try {
      log('🔵 Fetching interests grouped by type');
      
      final allInterests = await getAllInterests();
      
      final Map<String, List<InterestModel>> grouped = {};
      
      for (var interest in allInterests) {
        if (!grouped.containsKey(interest.type)) {
          grouped[interest.type] = [];
        }
        grouped[interest.type]!.add(interest);
      }
      
      log('✅ Grouped interests into ${grouped.length} categories');
      return grouped;
    } catch (e) {
      log('❌ Error grouping interests: $e');
      throw Exception('Failed to group interests: ${e.toString()}');
    }
  }

  // ============================================================================
  // SAVE USER INTERESTS (Updated to use interest IDs)
  // ============================================================================
  Future<void> saveUserInterests({
    required String userId,
    required List<String> interestNames,
  }) async {
    try {
      log('🔵 Saving ${interestNames.length} interests for user: $userId');
      
      // Delete existing interests first
      await supabase
          .from('user_skills')
          .delete()
          .eq('user_id', userId);
      
      // Insert new interests
      final skillsData = interestNames.map((name) => {
        'user_id': userId,
        'skill_name': name,
        'proficiency_level': 'beginner',
      }).toList();

      if (skillsData.isNotEmpty) {
        await supabase.from('user_skills').insert(skillsData);
      }
      
      log('✅ Interests saved successfully');
    } catch (e) {
      log('❌ Error saving interests: $e');
      throw Exception('Failed to save interests: ${e.toString()}');
    }
  }

  // ============================================================================
  // GET USER SELECTED INTERESTS
  // ============================================================================
  Future<List<String>> getUserInterests({required String userId}) async {
    try {
      log('🔵 Fetching interests for user: $userId');
      
      final response = await supabase
          .from('user_skills')
          .select('skill_name')
          .eq('user_id', userId);
      
      final interests = (response as List)
          .map((item) => item['skill_name'] as String)
          .toList();
      
      log('✅ Fetched ${interests.length} interests for user');
      return interests;
    } catch (e) {
      log('❌ Error fetching user interests: $e');
      return [];
    }
  }
}