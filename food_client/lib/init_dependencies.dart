import 'package:food_client/features/onboarding/viewmodel/cubit/onboarding_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void initDependencies() {
  // Cubit
  getIt.registerLazySingleton(() => OnboardingCubit());
}
