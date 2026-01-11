part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class DashboardLoadingState extends DashboardState {}

final class DashboardLoadedState extends DashboardState {}

final class DashboardStatusChanged extends DashboardState {}

final class DashboardMenteeChanged extends DashboardState {}

final class DashboardErrorState extends DashboardState {
  const DashboardErrorState({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}