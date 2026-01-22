import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Dashboard/data/model/mentee_model.dart';
import 'package:mistakes/features/Dashboard/data/remote/dash_repo.dart';

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

    loadMentees({required UserModel user}) async {
    emit(DashboardLoadingState());
    try {
      allMentees = await dashboardRepo.getMentees(mentorId: user.id!);
      filterMentees();
      log('Mentees loaded: ${allMentees.length}');
      emit(DashboardLoadedState());
    } catch (e) {
      log('Error loading mentees: $e');
      emit(DashboardErrorState(error:"Failed to load mentees"));
    }
  }

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

  void changeStatus(int index) {
    emit(DashboardLoadingState());
    selectedStatusIndex = index;
    log('Selected Status: ${status[index]}');
    filterMentees();
    emit(DashboardStatusChanged());
  }

  void setSelectedMenteeIndex(int index) {
    emit(DashboardLoadingState());
    selectedMenteeIndex = index;
    log('Selected Mentee Index: $selectedMenteeIndex');
    emit(DashboardMenteeChanged());
  }

  Future<void> setSelectedMentee(MenteeModel mentee) async {
    emit(DashboardLoadingState());
    try {
      selectedMentee = mentee;
      log('Loading detailed data for mentee: ${mentee.name}');

      await loadMenteeDetails(mentee.id, mentee.matchId);

      emit(DashboardMenteeChanged());
    } catch (e) {
      log('Error loading mentee details: $e');
      emit(DashboardErrorState(error: "Failed to load mentee details"));
    }
  }

  Future<void> loadMenteeDetails(String menteeId, String matchId) async {
    try {
      final matchData = await dashboardRepo.getMatchDetails(matchId);
      selectedMenteeRecentGoals = await dashboardRepo.getMenteeRecentGoals(
        menteeId: menteeId,
        limit: 5,
      );
      selectedMenteeDetails = {
        'match_id': matchId,
        'started_at': matchData['responded_at'] ?? matchData['created_at'],
        'recent_goals': selectedMenteeRecentGoals,
      };

      log('Loaded details for mentee: $menteeId');
    } catch (e) {
      log('Error loading mentee details: $e');
      rethrow;
    }
  }

  int get monthsTogether {
    if (selectedMenteeDetails['started_at'] == null) return 0;

    final startDate = DateTime.parse(selectedMenteeDetails['started_at']);
    final now = DateTime.now();

    final months =
        (now.year - startDate.year) * 12 + (now.month - startDate.month);

    return months;
  }

  int get activeGoalsCount {
    return selectedMentee?.totalGoals ??
        0 - (selectedMentee?.goalsCompleted ?? 0);
  }

  int get completedGoalsCount {
    log('Completed goals count: ${selectedMentee?.goalsCompleted}');
    return selectedMentee?.goalsCompleted ?? 0;
  }

  int get overallProgressPercentage {
    return selectedMentee?.overallProgress ?? 0;
  }
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
  void clearSelectedMentee() {
    selectedMentee = null;
    selectedMenteeDetails = {};
    selectedMenteeRecentGoals = [];
    emit(DashboardLoadedState());
  }

  Future<void> loadFeedbackForSelectedGoal() async {
    if (selectedRecentGoals.isEmpty) {
      log('No goal selected');
      return;
    }

    emit(DashboardLoadingState());
    try {
      final goalId = selectedRecentGoals['id'];
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

      log('Loaded feedback for goal $goalId');
      emit(DashboardLoadedState());
    } catch (e) {
      log('Error loading goal feedback: $e');
      selectedRecentGoals['has_feedback'] = false;
      emit(DashboardLoadedState());
    }
  }

  List<Map<String, dynamic>> needAttentionItems = [];
  Future<void> loadNeedAttentionItems(String userId) async {
    emit(DashboardLoadingState());
    try {
      needAttentionItems.clear();

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
      needAttentionItems.sort((a, b) {
        if (a['time'] == 'Now') return -1;
        if (b['time'] == 'Now') return 1;
        return 0; 
      });

      log('Loaded ${needAttentionItems.length} need attention items');
      emit(DashboardLoadedState());
    } catch (e) {
      log('Error loading need attention items: $e');
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


  void updateState() {
    emit(DashboardLoadingState());
    emit(DashboardLoadedState());
  }
}
