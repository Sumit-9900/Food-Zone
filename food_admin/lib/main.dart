import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_admin/core/routes/app_route_config.dart';
import 'package:food_admin/core/viewmodel/cubit/image_picker_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_admin/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:food_admin/features/food/viewmodel/bloc/food_bloc.dart';
import 'package:food_admin/features/order/viewmodel/bloc/order_bloc.dart';
import 'package:food_admin/init_dependencies.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  WidgetsFlutterBinding.ensureInitialized();

  const FirebaseOptions options = FirebaseOptions(
    apiKey: "AIzaSyC4AWP6gSYkZuhpF8qreEzVDGyspfoNjeo",
    authDomain: "food-app-6f1f3.firebaseapp.com",
    projectId: "food-app-6f1f3",
    storageBucket: "food-app-6f1f3.appspot.com",
    messagingSenderId: "82926148600",
    appId: "1:82926148600:web:dae244ef4dc46ab82a940d",
    measurementId: "G-3WWXBG9469",
  );

  await Firebase.initializeApp(options: options);

  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<FoodBloc>()),
        BlocProvider(create: (_) => getIt<ImagePickerCubit>()),
        BlocProvider(create: (_) => getIt<OrderBloc>()),
      ],
      child: MyApp(),
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
      routerConfig: AppRouteConfig.router,
    );
  }
}
