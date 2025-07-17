import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/features/bottomNav/viewmodel/cubit/bottom_nav_cubit.dart';
import 'package:food_client/features/cart/view/pages/cart_page.dart';
import 'package:food_client/features/favorite/view/pages/favorite_page.dart';
import 'package:food_client/features/food/view/pages/food_page.dart';
import 'package:food_client/features/profile/view/pages/profile_page.dart';
import 'package:food_client/init_dependencies.dart';

class BottomNavPage extends StatelessWidget {
  const BottomNavPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const FoodPage(),
      const FavoritePage(),
      const CartPage(),
      const ProfilePage(),
    ];

    return BlocProvider(
      create: (_) => getIt<BottomNavCubit>(),
      child: Builder(
        builder: (context) {
          return BlocSelector<BottomNavCubit, BottomNavState, int>(
            selector: (state) {
              if (state is BottomNavChanged) {
                return state.index;
              }
              return 0;
            },
            builder: (context, selectedIndex) {
              return Scaffold(
                bottomNavigationBar: CurvedNavigationBar(
                  height: 60.0,
                  index: selectedIndex,
                  items: const [
                    Icon(Icons.home_outlined, color: Colors.white),
                    Icon(Icons.favorite_outline, color: Colors.white),
                    Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    Icon(Icons.person_outline, color: Colors.white),
                  ],
                  color: Colors.black,
                  buttonBackgroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  onTap: context.read<BottomNavCubit>().changeNavIndex,
                ),
                body: pages[selectedIndex],
              );
            },
          );
        },
      ),
    );
  }
}
