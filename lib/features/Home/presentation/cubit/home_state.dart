part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeLoadedState extends HomeState {}

final class HomeLikeToggledState extends HomeState {}

// User search states
final class UserSearchLoadingState extends HomeState {}

final class UserSearchLoadedState extends HomeState {
  final List<UserModel> users;
  final String searchQuery;
  final String? roleFilter;
  final String? expertiseFilter;
  final double? minRating;
  final int? minExperience;

  const UserSearchLoadedState({
    required this.users,
    required this.searchQuery,
    this.roleFilter,
    this.expertiseFilter,
    this.minRating,
    this.minExperience,
  });

  @override
  List<Object?> get props => [
        users,
        searchQuery,
        roleFilter,
        expertiseFilter,
        minRating,
        minExperience,
      ];
}

final class UserSearchErrorState extends HomeState {
  final String error;

  const UserSearchErrorState(this.error);

  @override
  List<Object> get props => [error];
}