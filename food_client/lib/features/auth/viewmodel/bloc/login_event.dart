part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class LoginCompleted extends LoginEvent {
  final String email;
  final String password;
  LoginCompleted({required this.email, required this.password});
}
