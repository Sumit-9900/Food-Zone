import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/routes/route_config.dart';
import 'package:food_client/features/onboarding/viewmodel/cubit/onboarding_cubit.dart';
import 'package:food_client/init_dependencies.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => getIt<OnboardingCubit>())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quick Foodie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: RouteConfig().goRouter,
    );
  }
}
