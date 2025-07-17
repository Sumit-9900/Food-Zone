import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/constants/text_constants.dart';
import 'package:food_client/core/routes/route_constants.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/features/favorite/viewmodel/cubit/favorite_cubit.dart';
import 'package:food_client/features/food/models/food_model.dart';
import 'package:go_router/go_router.dart';

class FoodTile extends StatelessWidget {
  final FoodModel food;
  const FoodTile({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteConstants.foodDetails, extra: food);
      },
      child: Card(
        child: Container(
          width: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: food.productImage,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    BlocBuilder<FavoriteCubit, FavoriteState>(
                      builder: (context, state) {
                        final List<String> favIds =
                            (state is FavoriteSuccess) ? state.foodIds : [];

                        final isFav = favIds.contains(food.productId);

                        return Positioned(
                          right: 2,
                          top: 2,
                          child: IconButton(
                            onPressed: () {
                              context.read<FavoriteCubit>().toggleFavorite(
                                food,
                                favIds.toSet(),
                              );
                            },
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  food.productName,
                  style: Style.text8,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  food.productDetail,
                  style: Style.text2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${TextConstants.indianRuppee}${food.productPrice}',
                  style: Style.text8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
