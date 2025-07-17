import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/constants/text_constants.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/core/utils/show_snackbar.dart';
import 'package:food_client/core/widgets/loader.dart';
import 'package:food_client/features/cart/viewmodel/cubit/cart_cubit.dart';
import 'package:food_client/features/favorite/viewmodel/cubit/favorite_cubit.dart';
import 'package:food_client/features/food/models/food_model.dart';
import 'package:food_client/features/food/viewmodel/cubit/food_quantity_cubit.dart';
import 'package:food_client/init_dependencies.dart';

class FoodDetailsPage extends StatelessWidget {
  final FoodModel food;
  const FoodDetailsPage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FoodQuantityCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              actions: [
                BlocBuilder<FavoriteCubit, FavoriteState>(
                  builder: (context, state) {
                    final List<String> favIds =
                        (state is FavoriteSuccess) ? state.foodIds : [];

                    final isFav = favIds.contains(food.productId);

                    return IconButton(
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
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: food.productImage,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 2.3,
                      width: MediaQuery.of(context).size.width,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        SizedBox(
                          width: 250,
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              food.productName,
                              style: Style.text10,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            context.read<FoodQuantityCubit>().decrementQnty();
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.minus,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        BlocSelector<FoodQuantityCubit, FoodQuantityState, int>(
                          selector: (state) {
                            if (state is FoodQuantityChanged) {
                              return state.qnty;
                            }
                            return 1;
                          },
                          builder: (context, quantity) {
                            return SizedBox(
                              width: 30,
                              child: Center(
                                child: Text(
                                  quantity.toString(),
                                  style: Style.text1,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            context.read<FoodQuantityCubit>().incrementQnty();
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: SizedBox(
                        height: 160,
                        child: Text(
                          food.productDetail,
                          style: Style.text2,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Text('Delivery Time', style: Style.text10),
                          const SizedBox(width: 30),
                          Row(
                            children: [
                              const Icon(CupertinoIcons.clock),
                              const SizedBox(width: 5.0),
                              Text('30min', style: Style.text4),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Price', style: Style.text10),
                              Text(
                                '${TextConstants.indianRuppee}${food.productPrice}',
                                style: Style.text10,
                              ),
                            ],
                          ),
                          BlocConsumer<CartCubit, CartState>(
                            listener: (context, state) {
                              if (state is CartFailure) {
                                showSnackBar(
                                  context,
                                  message: state.message,
                                  color: Colors.red,
                                );
                              } else if (state is CartProductAdded) {
                                showSnackBar(
                                  context,
                                  message: 'Product added to Cart!',
                                  color: Colors.green,
                                );
                              }
                            },
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  final cubit =
                                      context.read<FoodQuantityCubit>();
                                  final state = cubit.state;
                                  int quantity = 1;
                                  if (state is FoodQuantityChanged) {
                                    quantity = state.qnty;
                                  }
                                  context.read<CartCubit>().addToCart(
                                    food,
                                    quantity,
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 1.8,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                      state is CartLoading
                                          ? const Loader()
                                          : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                'Add to Cart',
                                                style: Style.text7,
                                              ),
                                              const Icon(
                                                CupertinoIcons.cart,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
