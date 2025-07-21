import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_client/core/routes/route_constants.dart';
import 'package:food_client/features/auth/view/pages/fogot_password_page.dart';
import 'package:food_client/features/auth/view/pages/login_page.dart';
import 'package:food_client/features/auth/view/pages/signup_page.dart';
import 'package:food_client/features/bottomNav/view/pages/bottom_nav_page.dart';
import 'package:food_client/features/cart/models/address_model.dart';
import 'package:food_client/features/cart/view/pages/add_address_page.dart';
import 'package:food_client/features/cart/view/pages/shipping_page.dart';
import 'package:food_client/features/food/models/food_model.dart';
import 'package:food_client/features/food/view/pages/food_details_page.dart';
import 'package:food_client/features/onboarding/view/pages/onboard_page.dart';
import 'package:food_client/features/order/view/pages/order_page.dart';
import 'package:food_client/features/payment/view/pages/order_confirmation_page.dart';
import 'package:food_client/features/payment/view/pages/payment_page.dart';
import 'package:food_client/features/profile/view/pages/terms_conditions_screen.dart';
import 'package:go_router/go_router.dart';

class RouteConfig {
  final Listenable refreshListenable;
  RouteConfig({required this.refreshListenable});

  late final router = GoRouter(
    initialLocation: '/onboarding',
    refreshListenable: refreshListenable,
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
      GoRoute(
        path: '/bottom-nav',
        name: RouteConstants.bottomNavRoute,
        builder: (context, state) => const BottomNavPage(),
      ),
      GoRoute(
        path: '/terms-and-conditions',
        name: RouteConstants.termsAndConditions,
        builder: (context, state) => const TermsandConditionsScreen(),
      ),
      GoRoute(
        path: '/food-details',
        name: RouteConstants.foodDetails,
        builder: (context, state) {
          final food = state.extra as FoodModel;
          return FoodDetailsPage(food: food);
        },
      ),
      GoRoute(
        path: '/shipping',
        name: RouteConstants.shippingRoute,
        builder: (context, state) {
          final totalPrice = state.extra as double;
          return ShippingPage(totalPrice: totalPrice);
        },
      ),
      GoRoute(
        path: '/add-address',
        name: RouteConstants.addAddressRoute,
        builder: (context, state) {
          final address =
              state.extra == null ? null : state.extra as AddressModel;
          return AddAddressPage(address: address);
        },
      ),
      GoRoute(
        path: '/payment',
        name: RouteConstants.paymentRoute,
        builder: (context, state) {
          final totalPrice = state.extra as double;
          return PaymentPage(totalPrice: totalPrice);
        },
      ),
      GoRoute(
        path: '/order-confirm',
        name: RouteConstants.orderConfirmationRoute,
        builder: (context, state) {
          final totalPrice = state.extra as double;
          return OrderConfirmationPage(totalPrice: totalPrice);
        },
      ),
      GoRoute(
        path: '/orders',
        name: RouteConstants.orderRoute,
        builder: (context, state) => const OrderPage(),
      ),
    ],
    redirect: (context, state) {
      final loggedIn = FirebaseAuth.instance.currentUser != null;
      final goingToAuthPages = [
        '/onboarding',
        '/login',
        '/signup',
        '/forgot-password',
      ].contains(state.matchedLocation);

      if (!loggedIn && !goingToAuthPages) {
        return '/onboarding';
      } else if (loggedIn && goingToAuthPages) {
        return '/bottom-nav';
      }

      return null;
    },
    errorBuilder: (context, state) {
      return Scaffold(body: Center(child: Text('Error Page!')));
    },
  );
}
