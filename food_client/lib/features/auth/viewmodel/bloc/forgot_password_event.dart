part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordEvent {}

final class ForgotPasswordCompleted extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordCompleted(this.email);
}
