import 'package:flutter/material.dart';
import 'package:food_client/core/routes/route_constants.dart';
import 'package:food_client/features/auth/view/pages/fogot_password_page.dart';
import 'package:food_client/features/auth/view/pages/login_page.dart';
import 'package:food_client/features/auth/view/pages/signup_page.dart';
import 'package:food_client/features/onboarding/views/pages/onboard_page.dart';
import 'package:go_router/go_router.dart';

class RouteConfig {
  final goRouter = GoRouter(
    initialLocation: RouteConstants.onBoardingRoute,
    routes: [
      GoRoute(
        path: '/onboarding',
        name: RouteConstants.onBoardingRoute,
        builder: (context, state) => const OnBoardPage(),
      ),
      GoRoute(
        path: '/login',
        name: RouteConstants.logInRoute,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: RouteConstants.signUpRoute,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: RouteConstants.forgotPasswordRoute,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(body: Center(child: Text('Error Page!')));
    },
  );
}
