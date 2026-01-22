// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Goal/data/domain/goal_repo.dart';
import 'package:mistakes/features/Goal/data/model/goal_model.dart';
import 'package:mistakes/features/Goal/data/model/interest_model.dart';
import 'package:mistakes/global%20widgets/widgets/milestone.dart';

part 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  GoalRepo goalRepo;

  GoalCubit(this.goalRepo) : super(GoalInitial());

  UserModel user = UserModel();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final successCriteriaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<GoalModel> allGoals = [];
  List<GoalModel> filteredGoals = [];
  List<String> goalFilterOptions = ['All', 'Ongoing', 'Completed'];
  int selectedGoalFilterIndex = 0;

  String selectedCategory = 'skill';
  List<String> goalCategories = ['career', 'skill', 'personal'];
  DateTime? selectedDeadline;

  int selectedGoalIndex = 0;

  List<InterestModel> allInterests = [];

  Map<String, List<InterestModel>> groupedInterests = {};
  List<String> category = [];

  List<String> selectedInterests = [];

  Future<void> loadInterests() async {
    emit(GoalLoadingState());
    try {
      log('Loading interests from database');

      groupedInterests = await goalRepo.getInterestsGroupedByType();

      category = groupedInterests.keys.map((type) {
        return type[0].toUpperCase() + type.substring(1);
      }).toList();

      category.sort();

      log('Loaded interests in ${category.length} categories');
      log('Categories: $category');

      emit(GoalInterestsLoadedState());
    } catch (e) {
      log(' Error loading interests: $e');
      emit(GoalErrorState(error: 'Failed to load interests'));
    }
  }

  List<String> getInterestsForCategory(String categoryName) {
    final type = categoryName.toLowerCase();

    if (!groupedInterests.containsKey(type)) {
      return [];
    }

    return groupedInterests[type]!.map((interest) => interest.name).toList();
  }

  void addInterest(String interest) {
    if (!selectedInterests.contains(interest)) {
      emit(GoalLoadingState());
      selectedInterests.add(interest);
      log('Interest Added: $interest');
      log('Total Selected: ${selectedInterests.length}');
      emit(GoalInterestAddedState());
    }
  }

  void removeInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      emit(GoalLoadingState());
      selectedInterests.remove(interest);
      log('Interest Removed: $interest');
      log('Total Selected: ${selectedInterests.length}');
      emit(GoalInterestRemovedState());
    }
  }

  bool isInterestSelected(String interest) {
    return selectedInterests.contains(interest);
  }

  int get selectedInterestsCount => selectedInterests.length;

  Future<void> loadUserInterests() async {
    if (user.id == null) return;

    emit(GoalLoadingState());
    try {
      final interests = await goalRepo.getUserInterests(userId: user.id!);
      selectedInterests = interests;
      log('Loaded ${interests.length} user interests');
      emit(GoalLoadedState());
    } catch (e) {
      log(' Error loading user interests: $e');
      emit(GoalLoadedState());
    }
  }

  loadGoals(BuildContext? context) async {
    emit(GoalLoadingState());
    try {
      allGoals = await goalRepo.getGoals(menteeId: user.id!);
      filterGoals();
      loadGoalFeedback();
         if (context != null && context.mounted) {
      await checkMissedDeadlines(context);
    }
      log('Goals loaded: ${allGoals.length}');
      emit(GoalLoadedState());
    } catch (e) {
      log('Error loading goals: $e');
      emit(GoalErrorState(error: 'Failed to load goals'));
    }
  }

  void filterGoals() {
    switch (selectedGoalFilterIndex) {
      case 0: // All
        filteredGoals = allGoals;
        break;
      case 1: // Ongoing
        filteredGoals = allGoals
            .where((goal) => goal.status == 'active')
            .toList();
        break;
      case 2: // Completed
        filteredGoals = allGoals
            .where((goal) => goal.status == 'completed')
            .toList();
        break;
      default:
        filteredGoals = allGoals;
    }
    log('Filtered goals: ${filteredGoals.length}');
  }

  void changeGoalFilter(int index) {
    emit(GoalLoadingState());
    selectedGoalFilterIndex = index;
    filterGoals();
    log('Goal filter changed to: ${goalFilterOptions[index]}');
    emit(GoalRoleChangedState());
  }

  updateProgress(
    String goalId,
    int newProgress, {
    required BuildContext context,
  }) async {
    emit(GoalLoadingState());
    try {
      await goalRepo.updateGoalProgress(
        goalId: goalId,
        progressPercentage: newProgress,
      );

      allGoals = allGoals.map((goal) {
        if (goal.id == goalId) {
          return goal.copyWith(
            progressPercentage: newProgress,
            updatedAt: DateTime.now(),
            status: newProgress == 100 ? 'completed' : goal.status,
            completedAt: newProgress == 100 ? DateTime.now() : goal.completedAt,
          );
        }
        return goal;
      }).toList();

      filterGoals();

      log('Progress updated to $newProgress% for goal $goalId');
      if (newProgress == 50) {
        await checkAndShowAchievement(
          context,
          'progress_50_percent',
          AchievementType.progressMilestone,
          progressPercentage: 50,
        );
      } else if (newProgress == 75) {
        await checkAndShowAchievement(
          context,
          'progress_75_percent',
          AchievementType.progressMilestone,
          progressPercentage: 75,
        );
      } else if (newProgress == 100) {
        final completedCount = allGoals
            .where((g) => g.status == 'completed')
            .length;

        if (completedCount == 1) {
          await checkAndShowAchievement(
            context,
            'first_completed_goal',
            AchievementType.firstCompletedGoal,
          );
        }

        await checkAndShowAchievement(
          context,
          'goal_completed_$goalId',
          AchievementType.goalCompleted,
        );
      }

      emit(GoalProgressUpdatedState());
    } catch (e) {
      log('Error updating progress: $e');
      emit(GoalErrorState(error: "Failed to update progress"));
    }
  }

  createGoal({required BuildContext context, required String matchId}) async {
    emit(GoalLoadingState());
    try {
      await goalRepo.createGoal(
        matchId: matchId,
        menteeId: user.id!,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory,
        deadline: selectedDeadline,
      );

      titleController.clear();
      descriptionController.clear();
      selectedDeadline = null;

      await loadGoals(context);
      if (context.mounted) {
        await checkAndShowAchievement(
          context,
          'first_goal_created',
          AchievementType.firstGoal,
        );
      }
      log('Goal created successfully');
      emit(GoalCreatedState());
    } catch (e) {
      log('Error creating goal: $e');
      emit(
        GoalErrorState(
          error:
              "Failed to create goal. Check all fields and active mentorship",
        ),
      );
    }
  }
Future<void> checkMissedDeadlines(BuildContext context) async {
  final now = DateTime.now();

  final hasMissedGoal = allGoals.any((goal) {
    return goal.status != 'completed' &&
        goal.deadline != null &&
        goal.deadline!.isBefore(now);
  });

  if (hasMissedGoal) {
    await checkAndShowAchievement(
      context,
      'first_missed_deadline',
      AchievementType.firstMissedDeadline,
    );
  }
}

  deleteGoal(String goalId) async {
    emit(GoalLoadingState());
    try {
      await goalRepo.deleteGoal(goalId: goalId);
      allGoals.removeWhere((goal) => goal.id == goalId);
      filterGoals();
      log('Goal deleted successfully');
      emit(GoalDeletedState());
    } catch (e) {
      log('Error deleting goal: $e');
      emit(
        GoalErrorState(error: "Failed to delete goal. Please try again later"),
      );
    }
  }

  void changeCategory(String category) {
    emit(GoalLoadingState());
    selectedCategory = category;
    log('Category changed to: $category');
    emit(GoalLoadedState());
  }

  void setDeadline(DateTime? date) {
    emit(GoalLoadingState());
    selectedDeadline = date;
    log('Deadline set to: $date');
    emit(GoalLoadedState());
  }

  void setSelectedGoalIndex(int index) {
    emit(GoalLoadingState());
    selectedGoalIndex = index;
    log('Selected goal index: $index');
    emit(GoalLoadedState());
  }

  GoalModel? get selectedGoal {
    if (filteredGoals.isEmpty || selectedGoalIndex >= filteredGoals.length) {
      return null;
    }
    return filteredGoals[selectedGoalIndex];
  }

  int get overallProgressPercentage {
    if (allGoals.isEmpty) return 0;
    final totalProgress = allGoals.fold<int>(
      0,
      (sum, goal) => sum + goal.progressPercentage,
    );
    return totalProgress ~/ allGoals.length;
  }

  int get completedGoalsCount {
    return allGoals.where((goal) => goal.status == 'completed').length;
  }

  int get activeGoalsCount {
    return allGoals.where((goal) => goal.status == 'active').length;
  }

  Map<String, Map<String, dynamic>> goalFeedback = {};
  Future<void> loadGoalFeedback() async {
    try {
      for (var goal in allGoals) {
        try {
          final feedback = await goalRepo.getGoalFeedback(goal.id);

          if (feedback.isNotEmpty) {
            goalFeedback[goal.id] = {
              'has_feedback': true,
              'feedback_text': feedback.first['comment_text'],
              'feedback_rating': feedback.first['rating'],
              'mentor_name': feedback.first['mentor_name'],
            };
          } else {
            goalFeedback[goal.id] = {'has_feedback': false};
          }
        } catch (e) {
          log('Error loading feedback for goal ${goal.id}: $e');
          goalFeedback[goal.id] = {'has_feedback': false};
        }
      }

      log('Loaded feedback for ${goalFeedback.length} goals');
      emit(GoalLoadedState());
    } catch (e) {
      log('Error loading goal feedback: $e');
    }
  }

  void clear() {
    titleController.clear();
    descriptionController.clear();
    selectedCategory = 'skill';
    successCriteriaController.clear();
    selectedDeadline = null;
  }

  void updateState() {
    emit(GoalLoadingState());
    emit(GoalLoadedState());
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    successCriteriaController.dispose();
    return super.close();
  }
}
