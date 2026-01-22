part of 'authentication_cubit.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthLoadingState extends AuthenticationState {}

final class AuthLoadedState extends AuthenticationState {}

final class AuthRoleChangedState extends AuthenticationState {}

final class AddDetailsLoaded extends AuthenticationState {}

final class AddDetailsSuccess extends AuthenticationState {}

final class AddDetailsSkipped extends AuthenticationState {}

final class AuthLogoutState extends AuthenticationState {}
final class AuthInterestsSavedState extends AuthenticationState {}
final class AuthSignUpSuccessState extends AuthenticationState {}

final class AuthSignInSuccessState extends AuthenticationState {}

final class AuthAutoLoginSuccessState extends AuthenticationState {}

final class AuthProfileUpdatedState extends AuthenticationState {}

final class AuthPasswordResetEmailSentState extends AuthenticationState {}
final class AuthErrorState extends AuthenticationState {
  const AuthErrorState({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}

final class AddDetailsError extends AuthenticationState {
  const AddDetailsError(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class PasswordResetEmailSent extends AuthenticationState {
  final String email;

  const PasswordResetEmailSent(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordResetSuccess extends AuthenticationState {}

class PasswordResetError extends AuthenticationState {
  final String message;

  const PasswordResetError(this.message);

  @override
  List<Object> get props => [message];
}