import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_client/core/widgets/loader.dart';
import 'package:go_router/go_router.dart';
import 'package:food_client/core/routes/route_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    final user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;
    if (user == null) {
      context.goNamed(RouteConstants.onBoardingRoute);
    } else {
      context.goNamed(RouteConstants.bottomNavRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Loader());
  }
}
