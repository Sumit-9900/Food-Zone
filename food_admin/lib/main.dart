import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_admin/core/routes/app_route_config.dart';
import 'package:food_admin/core/viewmodel/cubit/image_picker_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_admin/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:food_admin/features/food/viewmodel/bloc/food_bloc.dart';
import 'package:food_admin/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Load environment variables first
  await dotenv.load(fileName: ".env");

  // Initialize Firebase with proper configuration
  FirebaseOptions options = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'],
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    appId: dotenv.env['FIREBASE_APP_ID']!,
    measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
  );

  await Firebase.initializeApp(options: options);

  // Initialize all dependencies and wait for completion
  await initDependencies();

  // Add small delay to ensure all services are ready
  await Future.delayed(const Duration(milliseconds: 100));

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<FoodBloc>()),
        BlocProvider(create: (_) => getIt<ImagePickerCubit>()),
      ],
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
      routerConfig: AppRouteConfig.router,
      builder: (context, child) {
        // Add error handling for widget building
        return child ?? const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
