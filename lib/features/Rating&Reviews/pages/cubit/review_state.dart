part of 'review_cubit.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

final class ReviewInitial extends ReviewState {}

final class ReviewLoadedState extends ReviewState {}
final class ReviewFeedbackSubmittedState extends ReviewState {}

final class ReviewFeedbackLoadedState extends ReviewState {}

final class ReviewStatusChanged extends ReviewState {}

final class ReviewLoading extends ReviewState {}

final class ReviewFeedbackLoading extends ReviewState {}

final class ReviewFeedbackAddedState extends ReviewState {}

final class ReviewErrorState extends ReviewState {
  final String error;

  const ReviewErrorState(this.error);

  @override
  List<Object> get props => [error];
}
