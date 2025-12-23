import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  GoalCubit() : super(GoalInitial());

  List<String> goals = ['All', 'Pending', 'Ongoing', 'Completed'];
  int selectedGoalIndex = 0;

  List<String> interests = [
    'Technology',
    'Health',
    'Finance',
    'Education',
    'Art',
    'Sports',
    'Travel',
    'Music',
    'Science',
    'Literature', 
  ];
  List<String> category = [
    'Health',
    'Career',
    'Personal Development',
    'Finance',
  ];

  // int selectedInterestIndex = 0;
  List<String> selectedInterests = [];

  void changeGoal(int index) {
    emit(GoalRoleChangedState());
    selectedGoalIndex = index;
    log('Selected Goal Index: $selectedGoalIndex');
    emit(GoalLoadedState());
  }

    // Add interest (only if not already selected)
  void addInterest(String interest) {
    if (!selectedInterests.contains(interest)) {
      emit(GoalLoadingState());
      selectedInterests.add(interest);
      log('Interest Added: $interest');
      log('Total Selected: ${selectedInterests.length}');
      emit(GoalInterestAddedState());
    }
  }

  // Remove interest
  void removeInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      emit(GoalLoadingState());
      selectedInterests.remove(interest);
      log('Interest Removed: $interest');
      log('Total Selected: ${selectedInterests.length}');
      emit(GoalInterestRemovedState());
    }
  }

  // Check if selected
  bool isInterestSelected(String interest) {
    return selectedInterests.contains(interest);
  }

  // Get count
  int get selectedInterestsCount => selectedInterests.length;
}
