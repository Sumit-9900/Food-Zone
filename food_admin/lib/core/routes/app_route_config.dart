import 'package:flutter/material.dart';
import 'package:food_admin/core/routes/app_route_constants.dart';
import 'package:food_admin/features/auth/repository/auth_local_repository.dart';
import 'package:food_admin/features/auth/view/pages/login_page.dart';
import 'package:food_admin/features/food/models/food_model.dart';
import 'package:food_admin/features/food/view/pages/add_food_page.dart';
import 'package:food_admin/features/food/view/pages/food_page.dart';
import 'package:food_admin/init_dependencies.dart';
import 'package:go_router/go_router.dart';

class AppRouteConfig {
  static GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        name: AppRouteConstants.loginRouteName,
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: AppRouteConstants.foodsRouteName,
        path: '/foods',
        builder: (context, state) => const FoodPage(),
      ),
      GoRoute(
        name: AppRouteConstants.addNewFoodRouteName,
        path: '/add-food',
        builder: (context, state) {
          final food = state.extra == null ? null : state.extra as FoodModel;
          return AddFoodPage(food: food);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(body: Center(child: Text('Error Page!')));
    },
    redirect: (context, state) {
      final isLoggedIn = getIt<AuthLocalRepository>().getIsLoggedIn();
      final loggingIn = state.uri.path == AppRouteConstants.loginRouteName;

      if (!isLoggedIn && !loggingIn) {
        return AppRouteConstants.loginRouteName;
      } else if (isLoggedIn && loggingIn) {
        return AppRouteConstants.foodsRouteName;
      }

      return null;
    },
  );
}
