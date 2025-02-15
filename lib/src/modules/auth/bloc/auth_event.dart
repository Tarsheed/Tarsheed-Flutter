part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

final class RegisterWithEmailAndPasswordEvent extends AuthEvent {
  final EmailAndPasswordRegistrationForm form;
  const RegisterWithEmailAndPasswordEvent({required this.form});
  @override
  List<Object?> get props => [form];
}

final class LoginWithEmailAndPasswordEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginWithEmailAndPasswordEvent(
      {required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

final class VerifyEmailEvent extends AuthEvent {
  final String code;
  const VerifyEmailEvent(this.code);
  @override
  List<Object?> get props => [code];
}

final class ResendVerificationCodeEvent extends AuthEvent {
  const ResendVerificationCodeEvent();
  @override
  List<Object?> get props => [];
}

class ConfirmForgotPasswordCode extends AuthEvent {
  final String code;
  const ConfirmForgotPasswordCode(this.code);
  @override
  List<Object?> get props => [code];
}

final class ResetPasswordEvent extends AuthEvent {
  final String newPassword;
  const ResetPasswordEvent(this.newPassword);
  @override
  List<Object?> get props => [newPassword];
}

final class LogoutEvent extends AuthEvent {
  const LogoutEvent();
  @override
  List<Object?> get props => [];
}
