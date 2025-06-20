import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingSuccess(0));

  void onPageChanged(int index) {
    emit(OnboardingSuccess(index));
  }
}
