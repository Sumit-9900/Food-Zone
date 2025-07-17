import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_client/core/routes/route_config.dart';
import 'package:food_client/core/theme/app_theme.dart';
import 'package:food_client/features/auth/viewmodel/bloc/forgot_password_bloc.dart';
import 'package:food_client/features/auth/viewmodel/bloc/login_bloc.dart';
import 'package:food_client/features/auth/viewmodel/bloc/signup_bloc.dart';
import 'package:food_client/features/cart/viewmodel/cubit/address_cubit.dart';
import 'package:food_client/features/cart/viewmodel/cubit/cart_cubit.dart';
import 'package:food_client/features/favorite/viewmodel/cubit/favorite_cubit.dart';
import 'package:food_client/features/food/viewmodel/bloc/food_bloc.dart';
import 'package:food_client/features/onboarding/viewmodel/cubit/onboarding_cubit.dart';
import 'package:food_client/features/payment/viewmodel/cubit/payment_cubit.dart';
import 'package:food_client/features/profile/viewmodel/cubit/profile_cubit.dart';
import 'package:food_client/init_dependencies.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await dotenv.load(fileName: ".env");

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

  initDependencies();

  GoRouter router = RouteConfig().router;
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    router.refresh();
  });

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  await Stripe.instance.applySettings();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<OnboardingCubit>()),
        BlocProvider(create: (_) => getIt<SignupBloc>()),
        BlocProvider(create: (_) => getIt<LoginBloc>()),
        BlocProvider(create: (_) => getIt<ForgotPasswordBloc>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()),
        BlocProvider(create: (_) => getIt<FoodBloc>()..add(FoodFetched())),
        BlocProvider(
          create: (_) => getIt<FavoriteCubit>()..getFavoriteProducts(),
        ),
        BlocProvider(create: (_) => getIt<CartCubit>()..fetchCartProducts()),
        BlocProvider(create: (_) => getIt<AddressCubit>()..getUserAddresses()),
        BlocProvider(create: (_) => getIt<PaymentCubit>()),
      ],
      child: MyApp(router: router),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quick Foodie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
