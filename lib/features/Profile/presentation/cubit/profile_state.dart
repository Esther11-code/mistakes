part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {}

class SelectedMentorLoadingState extends ProfileState {}

class SelectedMentorState extends ProfileState {}

class GoalsUpdatedState extends ProfileState {
  final List<String> selectedGoals;

  const GoalsUpdatedState({required this.selectedGoals});

  @override
  List<Object> get props => [selectedGoals];
}

class RequestSentState extends ProfileState {}

class RequestAcceptedState extends ProfileState {}

class RequestDeclinedState extends ProfileState {}

class ProfileErrorState extends ProfileState {
  final String error;

  const ProfileErrorState(this.error);

  @override
  List<Object> get props => [error];
}