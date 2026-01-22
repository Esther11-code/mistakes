part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class NotificationLoadingState extends NotificationState {}

final class NotificationLoadedState extends NotificationState {}

final class NotificationErrorState extends NotificationState {
  final String error;

  const NotificationErrorState(this.error);

  @override
  List<Object> get props => [error];
}