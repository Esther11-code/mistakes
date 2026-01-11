part of 'goal_cubit.dart';

sealed class GoalState extends Equatable {
  const GoalState();

  @override
  List<Object> get props => [];
}

final class GoalInitial extends GoalState {}

final class GoalLoadingState extends GoalState {}

final class GoalLoadedState extends GoalState {}

final class GoalRoleChangedState extends GoalState {}

final class GoalProgressUpdatedState extends GoalState {}

final class GoalCreatedState extends GoalState {}

final class GoalDeletedState extends GoalState {}

final class GoalInterestAddedState extends GoalState {}

final class GoalInterestRemovedState extends GoalState {}
final class GoalInterestsLoadedState extends GoalState {}

final class GoalErrorState extends GoalState {
  const GoalErrorState({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}