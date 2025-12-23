part of 'onboarding_cubit.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingLoadingState extends OnboardingState {}

final class OnboardingLoadedState extends OnboardingState {}

final class Newuserstate extends OnboardingState {}

final class AutoLoginState extends OnboardingState {}
final class OnboardingButtonChangedState extends OnboardingState {}

final class OnboardingError extends OnboardingState {
  final String error;
  const OnboardingError({required this.error});
  @override
  List<Object> get props => [];
}
