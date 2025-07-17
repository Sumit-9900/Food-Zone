import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/features/auth/repository/auth_remote_repository.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRemoteRepository _authRemoteRepository;
  ForgotPasswordBloc({required AuthRemoteRepository authRemoteRepository})
    : _authRemoteRepository = authRemoteRepository,
      super(ForgotPasswordInitial()) {
    on<ForgotPasswordCompleted>(_onFogotPassword);
  }

  void _onFogotPassword(
    ForgotPasswordCompleted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    
    final res = await _authRemoteRepository.forgotPassword(event.email);

    res.fold(
      (l) => emit(ForgotPasswordFailure(l.message)),
      (_) => emit(ForgotPasswordSuccess()),
    );
  }
}
