import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/features/auth/repository/auth_remote_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteRepository _authRemoteRepository;
  LoginBloc({required AuthRemoteRepository authRemoteRepository})
    : _authRemoteRepository = authRemoteRepository,
      super(LoginInitial()) {
    on<LoginCompleted>(_onLogin);
  }

  void _onLogin(LoginCompleted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    final res = await _authRemoteRepository.logIn(
      email: event.email,
      password: event.password,
    );

    res.fold(
      (l) => emit(LoginFailure(l.message)),
      (r) => emit(LoginSuccess(r)),
    );
  }
}
