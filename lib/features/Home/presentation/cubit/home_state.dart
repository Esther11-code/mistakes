part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}
final class HomeLoadingState extends HomeState {}

final class HomeLoadedState extends HomeState {}
final class HomeButtonChangedState extends HomeState {}

final class HomeError extends HomeState {
  final String error;
  const HomeError({required this.error});
  @override
  List<Object> get props => [];
}