part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileAuthLoading extends ProfileState {}

final class ProfileFetched extends ProfileState {
  final UserModel user;
  ProfileFetched({required this.user});
}

final class ProfileLoggedOut extends ProfileState {}

final class ProfileAccountDeleted extends ProfileState {}

final class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);
}
