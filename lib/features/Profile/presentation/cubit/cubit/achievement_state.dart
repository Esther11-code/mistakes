part of 'achievement_cubit.dart';

sealed class AchievementState extends Equatable {
  const AchievementState();

  @override
  List<Object> get props => [];
}

final class AchievementInitial extends AchievementState {}

final class AchievementPendingState extends AchievementState {}

final class AchievementNoPendingState extends AchievementState {}

final class AchievementShownState extends AchievementState {}