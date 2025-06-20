part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingSuccess extends OnboardingState {
  final int index;
  OnboardingSuccess(this.index);
}
