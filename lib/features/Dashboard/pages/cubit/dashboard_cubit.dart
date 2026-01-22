import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Dashboard/data/local/model/mentor_model.dart';
import 'package:mistakes/features/Dashboard/data/local/remote/dash_repo.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardRepo dashboardRepo;

  DashboardCubit(this.dashboardRepo) : super(DashboardInitial());

  UserModel user = UserModel();

  int selectedStatusIndex = 1;
  List<String> status = ['All', 'Needs Action', 'On Track'];

  int selectedMenteeIndex = 0;
  List<MenteeModel> allMentees = [];
  List<MenteeModel> filteredMentees = [];

  MenteeModel? selectedMentee;
  Map<String, dynamic> selectedMenteeDetails = {};
  List<Map<String, dynamic>> selectedMenteeRecentGoals = [];

  // ============================================================================
  // LOAD MENTEES
  // ============================================================================
  loadMentees({required UserModel user}) async {
    emit(DashboardLoadingState());
    try {
      allMentees = await dashboardRepo.getMentees(mentorId: user.id!);
      filterMentees();
      log('Mentees loaded: ${allMentees.length}');
      emit(DashboardLoadedState());
    } catch (e) {
      log('Error loading mentees: $e');
      emit(DashboardErrorState(error: e.toString()));
      emit(DashboardLoadedState());
    }
  }

  // ============================================================================
  // FILTER MENTEES
  // ============================================================================
  void filterMentees() {
    switch (selectedStatusIndex) {
      case 0: // All
        filteredMentees = allMentees;
        break;
      case 1: // Needs Action
        filteredMentees = allMentees.where((mentee) {
          return mentee.needsAction;
        }).toList();
        break;
      case 2: // On Track
        filteredMentees = allMentees.where((mentee) {
          return mentee.isOnTrack;
        }).toList();
        break;
      default:
        filteredMentees = allMentees;
    }
    log(
      'Filtered mentees: ${filteredMentees.length} (Status: ${status[selectedStatusIndex]})',
    );
  }

  // ============================================================================
  // CHANGE STATUS FILTER
  // ============================================================================
  void changeStatus(int index) {
    emit(DashboardLoadingState());
    selectedStatusIndex = index;
    log('Selected Status: ${status[index]}');
    filterMentees();
    emit(DashboardStatusChanged());
    emit(DashboardLoadedState());
  }

  // ============================================================================
  // SET SELECTED MENTEE BY INDEX
  // ============================================================================
  void setSelectedMenteeIndex(int index) {
    emit(DashboardLoadingState());
    selectedMenteeIndex = index;
    log('Selected Mentee Index: $selectedMenteeIndex');
    emit(DashboardMenteeChanged());
    emit(DashboardLoadedState());
  }

  // ============================================================================
  // ⭐ SET SELECTED MENTEE (Direct)
  // ============================================================================
  Future<void> setSelectedMentee(MenteeModel mentee) async {
    emit(DashboardLoadingState());
    try {
      selectedMentee = mentee;
      log('🔵 Loading detailed data for mentee: ${mentee.name}');

      // Load detailed data for this mentee
      await loadMenteeDetails(mentee.id, mentee.matchId);

      emit(DashboardMenteeChanged());
      emit(DashboardLoadedState());
    } catch (e) {
      log('❌ Error loading mentee details: $e');
      emit(DashboardErrorState(error: e.toString()));
      emit(DashboardLoadedState());
    }
  }

  // ============================================================================
  // ⭐ LOAD MENTEE DETAILS
  // ============================================================================
  Future<void> loadMenteeDetails(String menteeId, String matchId) async {
    try {
      // Get mentorship start date
      final matchData = await dashboardRepo.getMatchDetails(matchId);

      // Get recent goals (last 5)
      selectedMenteeRecentGoals = await dashboardRepo.getMenteeRecentGoals(
        menteeId: menteeId,
        limit: 5,
      );

      // Store additional details
      selectedMenteeDetails = {
        'match_id': matchId,
        'started_at': matchData['responded_at'] ?? matchData['created_at'],
        'recent_goals': selectedMenteeRecentGoals,
      };

      log('✅ Loaded details for mentee: $menteeId');
    } catch (e) {
      log('❌ Error loading mentee details: $e');
      rethrow;
    }
  }

  // ============================================================================
  // ⭐ DYNAMIC STATS GETTERS
  // ============================================================================

  // Calculate months together
  int get monthsTogether {
    if (selectedMenteeDetails['started_at'] == null) return 0;

    final startDate = DateTime.parse(selectedMenteeDetails['started_at']);
    final now = DateTime.now();

    final months =
        (now.year - startDate.year) * 12 + (now.month - startDate.month);

    return months;
  }

  // Get active goals count
  int get activeGoalsCount {
    return selectedMentee?.totalGoals ??
        0 - (selectedMentee?.goalsCompleted ?? 0);
  }

  // Get completed goals count
  int get completedGoalsCount {
    log('Completed goals count: ${selectedMentee?.goalsCompleted}');
    return selectedMentee?.goalsCompleted ?? 0;
  }

  // Get overall progress percentage
  int get overallProgressPercentage {
    return selectedMentee?.overallProgress ?? 0;
  }

  // Get stats list for GridView
  List<Map<String, dynamic>> get menteeStats {
    if (selectedMentee == null) {
      return [
        {'stat': '0', 'title': 'Total Goals'},
        {'stat': '0', 'title': 'Completed'},
        {'stat': '0', 'title': 'Months Together'},
        {'stat': '0%', 'title': 'Progress'},
      ];
    }

    return [
      {'stat': '${selectedMentee!.totalGoals}', 'title': 'Total Goals'},
      {'stat': '${selectedMentee!.goalsCompleted}', 'title': 'Completed'},
      {'stat': '$monthsTogether', 'title': 'Months Together'},
      {'stat': '${selectedMentee!.overallProgress}%', 'title': 'Progress'},
    ];
  }

  // Get recent goals
  List<Map<String, dynamic>> get recentGoals {
    return selectedMenteeRecentGoals;
  }

  Map<String, dynamic> selectedRecentGoals = {};

  void setSelectedRecentGoal({required Map<String, dynamic> recentGoals}) {
    emit(DashboardLoadingState());
    selectedRecentGoals = recentGoals;
    log('Selected recent goals: ${selectedRecentGoals.length}');
    emit(DashboardLoadedState());
  }

  // ============================================================================
  // CLEAR SELECTED MENTEE
  // ============================================================================
  void clearSelectedMentee() {
    selectedMentee = null;
    selectedMenteeDetails = {};
    selectedMenteeRecentGoals = [];
    emit(DashboardLoadedState());
  }

  // Add to DashboardCubit class
  // Load feedback for a specific goal
  Future<void> loadFeedbackForSelectedGoal() async {
    if (selectedRecentGoals.isEmpty) {
      log('⚠️ No goal selected');
      return;
    }

    emit(DashboardLoadingState());
    try {
      final goalId = selectedRecentGoals['id'];

      // Get comments for this goal
      final comments = await dashboardRepo.getGoalFeedback(goalId);

      // Add feedback to the selected goal
      if (comments.isNotEmpty) {
        // Get the latest feedback
        final latestFeedback = comments.first;
        selectedRecentGoals['has_feedback'] = true;
        selectedRecentGoals['feedback_text'] = latestFeedback['comment_text'];
        selectedRecentGoals['feedback_rating'] = latestFeedback['rating'];
        selectedRecentGoals['mentor_name'] = latestFeedback['mentor_name'];
      } else {
        selectedRecentGoals['has_feedback'] = false;
      }

      log('✅ Loaded feedback for goal $goalId');
      emit(DashboardLoadedState());
    } catch (e) {
      log('❌ Error loading goal feedback: $e');
      selectedRecentGoals['has_feedback'] = false;
      emit(DashboardLoadedState());
    }
  }

  // Add to DashboardCubit class
  List<Map<String, dynamic>> needAttentionItems = [];

  // Load need attention items
  Future<void> loadNeedAttentionItems(String userId) async {
    emit(DashboardLoadingState());
    try {
      needAttentionItems.clear();

      // 1. Check for completed goals (last 7 days)
      final completedGoals = await dashboardRepo.getRecentCompletedGoals(
        userId,
      );
      for (var goal in completedGoals) {
        needAttentionItems.add({
          'type': 'goal_completed',
          'icon': Icons.check_circle_outline,
          'color': Colors.green.shade400,
          'title': 'Goal Completed',
          'subtitle': goal['title'],
          'time': _formatTime(DateTime.parse(goal['completed_at'])),
          'route': Routename.goalSetUp,
          'data': goal,
        });
      }

      // 2. Check for unread messages
      final unreadCount = await dashboardRepo.getUnreadMessagesCount(userId);
      if (unreadCount > 0) {
        needAttentionItems.add({
          'type': 'new_message',
          'icon': Icons.message_outlined,
          'color': Colors.blue.shade400,
          'title': 'New Message${unreadCount > 1 ? 's' : ''}',
          'subtitle':
              '$unreadCount unread message${unreadCount > 1 ? 's' : ''}',
          'time': 'Now',
          'route': Routename.menteeChat,
          'data': {'count': unreadCount},
        });
      }

      // 3. Check for new shared resources (unread)
      final newResources = await dashboardRepo.getUnreadSharedResources(userId);
      for (var resource in newResources) {
        needAttentionItems.add({
          'type': 'resource_shared',
          'icon': Icons.book_outlined,
          'color': Colors.purple.shade400,
          'title': 'Resource Shared',
          'subtitle': resource['resource_title'],
          'time': _formatTime(DateTime.parse(resource['created_at'])),
          'route': Routename.sharedResources,
          'data': resource,
        });
      }

      // 4. Check for new achievements (last 7 days)
      final newAchievements = await dashboardRepo.getRecentAchievements(userId);
      for (var achievement in newAchievements) {
        needAttentionItems.add({
          'type': 'achievement',
          'icon': Icons.emoji_events_outlined,
          'color': Colors.orange.shade400,
          'title': 'Achievement Unlocked',
          'subtitle': _getAchievementTitle(achievement['achievement_type']),
          'time': _formatTime(DateTime.parse(achievement['achieved_at'])),
          'route': Routename.achievementHistory,
          'data': achievement,
        });
      }

      // 5. Check for new feedback on goals
      final newFeedback = await dashboardRepo.getRecentGoalFeedback(userId);
      for (var feedback in newFeedback) {
        needAttentionItems.add({
          'type': 'feedback_received',
          'icon': Icons.feedback_outlined,
          'color': Colors.pink.shade400,
          'title': 'Feedback Received',
          'subtitle': feedback['goal_title'],
          'time': _formatTime(DateTime.parse(feedback['created_at'])),
          'route': Routename.goalSetUp,
          'data': feedback,
        });
      }

      // Sort by time (most recent first)
      needAttentionItems.sort((a, b) {
        if (a['time'] == 'Now') return -1;
        if (b['time'] == 'Now') return 1;
        return 0; // Keep database order for others
      });

      log('✅ Loaded ${needAttentionItems.length} need attention items');
      emit(DashboardLoadedState());
    } catch (e) {
      log('❌ Error loading need attention items: $e');
      emit(DashboardLoadedState());
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String _getAchievementTitle(String type) {
    switch (type) {
      case 'first_goal_created':
        return 'First Goal Created';
      case 'progress_50_percent':
        return '50% Progress Milestone';
      case 'progress_75_percent':
        return '75% Progress Milestone';
      case 'first_mentorship_started':
        return 'First Mentorship Started';
      case 'first_bookmark_added':
        return 'First Bookmark Added';
      default:
        return 'New Achievement';
    }
  }

  // ============================================================================
  // UPDATE STATE
  // ============================================================================
  void updateState() {
    emit(DashboardLoadingState());
    emit(DashboardLoadedState());
  }
}
