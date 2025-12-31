part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeLikeToggledState extends HomeState {}

final class HomeLoadedState extends HomeState {}

final class HomeButtonChangedState extends HomeState {}

final class HomeError extends HomeState {
  final String error;
  const HomeError({required this.error});
  @override
  List<Object> get props => [];
}

class UserSearchLoadingState extends HomeState {}

class UserSearchLoadedState extends HomeState {
  final List<UserModel> users;
  final String searchQuery;
  final String? roleFilter;
  final String? expertiseFilter;
  final double? minRating;
  final int? minExperience;

  const UserSearchLoadedState({
    this.users = const [],
    this.searchQuery = '',
    this.roleFilter,
    this.expertiseFilter,
    this.minRating,
    this.minExperience,
  });

  @override
  List<Object> get props => [
    users, 
    searchQuery,
    roleFilter ?? '',
    expertiseFilter ?? '',
    minRating ?? 0.0,
    minExperience ?? 0,
  ];
}

class UserSearchErrorState extends HomeState {
  final String error;

  const UserSearchErrorState(this.error);

  @override
  List<Object> get props => [error];
}