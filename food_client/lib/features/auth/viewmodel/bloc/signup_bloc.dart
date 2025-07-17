import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/features/auth/repository/auth_remote_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRemoteRepository _authRemoteRepository;
  SignupBloc({required AuthRemoteRepository authRemoteRepository})
    : _authRemoteRepository = authRemoteRepository,
      super(SignupInitial()) {
    on<SignupCompleted>(_onSignup);
  }

  void _onSignup(SignupCompleted event, Emitter<SignupState> emit) async {
    emit(SignupLoading());

    final res = await _authRemoteRepository.signUp(
      name: event.name,
      email: event.email,
      password: event.password,
    );

    res.fold(
      (l) => emit(SignupFailure(l.message)),
      (r) => emit(SignupSuccess(r)),
    );
  }
}
