part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthErrorState extends AuthState {
  final Exception exception;
  const AuthErrorState({required this.exception});
  @override
  List<Object> get props => [exception];
}

final class RegisterLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

final class RegisterSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

final class LoginLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

final class LoginSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

final class VerifyEmailLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

final class VerifyEmailSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

final class ResendVerificationCodeLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

final class ResendVerificationCodeSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

final class ConfirmForgotPasswordCodeLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

final class ConfirmForgotPasswordCodeSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

final class ResetPasswordLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

final class ResetPasswordSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

final class LogoutLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

final class LogoutSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}
