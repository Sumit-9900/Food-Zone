import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/core/utils/show_snackbar.dart';
import 'package:food_client/core/widgets/loader.dart';
import 'package:food_client/features/favorite/view/widgets/favorite_product_tile.dart';
import 'package:food_client/features/favorite/viewmodel/cubit/favorite_cubit.dart';
import 'package:food_client/features/food/viewmodel/bloc/food_bloc.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Food Favorites')),
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocConsumer<FavoriteCubit, FavoriteState>(
            listener: (context, state) {
              if (state is FavoriteFailure) {
                showSnackBar(
                  context,
                  message: state.message,
                  color: Colors.red,
                );
              }
            },
            builder: (context, favState) {
              final foodState = context.watch<FoodBloc>().state;

              if (favState is FavoriteLoading || foodState is FoodLoading) {
                return const Loader();
              } else if (favState is FavoriteSuccess &&
                  foodState is FoodSuccess) {
                final favIds = favState.foodIds;
                final allFoods = foodState.allFoods;

                final favFoods =
                    allFoods
                        .where((food) => favIds.contains(food.productId))
                        .toList();

                if (favFoods.isEmpty) {
                  return Center(
                    child: Text(
                      'No favorites yet!',
                      style: Style.text2.copyWith(fontSize: 22.0),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: favFoods.length,
                  itemBuilder: (context, index) {
                    return FavoriteProductTile(food: favFoods[index]);
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
