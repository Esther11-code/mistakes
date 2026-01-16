part of 'mentor_cubit.dart';

sealed class MentorState extends Equatable {
  const MentorState();

  @override
  List<Object> get props => [];
}

final class MentorInitial extends MentorState {}

final class MentorLoadingState extends MentorState {}

final class MentorLoadedState extends MentorState {}

final class MentorErrorState extends MentorState {
  final String error;
  const MentorErrorState(this.error);

  @override
  List<Object> get props => [error];
}

final class MentorRequestAcceptedState extends MentorState {}

final class MentorRequestDeclinedState extends MentorState {}