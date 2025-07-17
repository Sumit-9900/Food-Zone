part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

final class SignupCompleted extends SignupEvent {
  final String name;
  final String email;
  final String password;
  SignupCompleted({
    required this.name,
    required this.email,
    required this.password,
  });
}
