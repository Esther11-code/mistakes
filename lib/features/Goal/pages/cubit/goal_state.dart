part of 'goal_cubit.dart';

sealed class GoalState extends Equatable {
  const GoalState();

  @override
  List<Object> get props => [];
}

final class GoalInitial extends GoalState {}

final class GoalLoadingState extends GoalState {}

final class GoalLoadedState extends GoalState {}

final class GoalDeletedState extends GoalState {}

final class GoalLogoutState extends GoalState {}

final class GoalTokenVerifiedState extends GoalState {}

final class GoalRegisterState extends GoalState {}

final class GoalEmailVerifiedState extends GoalState {}

final class GoalEmailOtpSentState extends GoalState {}

final class GoalRoleChangedState extends GoalState {}

final class GoalInterestSelectedState extends GoalState {}

final class GoalInterestAddedState extends GoalState {}

final class GoalInterestRemovedState extends GoalState {}
final class GoalErrorState extends GoalState {
  final String message;
  const GoalErrorState(this.message);

  @override
  List<Object> get props => [message];
}