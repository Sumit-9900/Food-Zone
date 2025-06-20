import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_admin/features/auth/repository/auth_local_repository.dart';
import 'package:food_admin/features/auth/repository/auth_remote_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteRepository _authRemoteRepository;
  final AuthLocalRepository _authLocalRepository;
  AuthBloc({
    required AuthRemoteRepository authRemoteRepository,
    required AuthLocalRepository authLocalRepository,
  }) : _authRemoteRepository = authRemoteRepository,
       _authLocalRepository = authLocalRepository,
       super(AuthInitial()) {
    on<AuthLogin>(_onAuthLogin);
    on<AuthLogout>(_onLogout);
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _authRemoteRepository.login(
      username: event.username,
      password: event.password,
    );

    if (res.isLeft()) {
      emit(AuthFailure("Unknown error"));
      return;
    }

    final user = res.getOrElse(() => throw Exception("Unexpected null user"));

    if (event.username == user.username && event.password == user.password) {
      final res1 = await _authLocalRepository.setIsLoggedIn(true);

      if (res1.isLeft()) {
        emit(AuthFailure("Preference error"));
        return;
      }

      emit(AuthSuccess());
    } else {
      emit(AuthFailure('The Username or Password are Invalid!!!'));
    }
  }

  void _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _authLocalRepository.logOut();

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthLogoutSuccess()),
    );
  }
}
