part of 'authentication_cubit.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthLoadingState extends AuthenticationState {}

final class AuthLoadedState extends AuthenticationState {}

final class AcctDeletedState extends AuthenticationState {}

final class AuthLogoutState extends AuthenticationState {}

final class AuthTokenVerifiedState extends AuthenticationState {}

final class AuthRegisterState extends AuthenticationState {}

final class LoginState extends AuthenticationState {}

final class AuthEmailVerifiedState extends AuthenticationState {}

final class AuthEmailOtpSentState extends AuthenticationState {}

final class AuthRoleChangedState extends AuthenticationState {}

final class InvalidOtpState extends AuthenticationState {
  final String msg;
  const InvalidOtpState({required this.msg});
  @override
  List<Object> get props => [];
}

final class AuthTokenSentState extends AuthenticationState {}

final class AuthErrorState extends AuthenticationState {
  const AuthErrorState({required this.error});
  final String error;
  @override
  List<Object> get props => [];
}
