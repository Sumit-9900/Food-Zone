import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/constants/image_constants.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/core/utils/capitalize_name.dart';
import 'package:food_client/core/utils/show_snackbar.dart';
import 'package:food_client/core/widgets/loader.dart';
import 'package:food_client/features/food/view/widgets/food_tile.dart';
import 'package:food_client/features/food/viewmodel/bloc/food_bloc.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      ImageConstants.saladImage,
      ImageConstants.iceCreamImage,
      ImageConstants.burgerImage,
      ImageConstants.pizzaImage,
    ];

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          color: Colors.black87,
          backgroundColor: Colors.white,
          onRefresh: () async {
            context.read<FoodBloc>().add(FoodFetched());
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BlocSelector<FoodBloc, FoodState, String>(
                      selector: (state) {
                        if (state is FoodSuccess) {
                          return state.user.username;
                        }
                        return '';
                      },
                      builder: (context, username) {
                        final name = capitalizeName(username);
                        return Text('Hello $name,', style: Style.text1);
                      },
                    ),
                    BlocSelector<FoodBloc, FoodState, String>(
                      selector: (state) {
                        if (state is FoodSuccess) {
                          return state.user.userImage;
                        }
                        return ImageConstants.profileDefaultLogo;
                      },
                      builder: (context, profileImage) {
                        return CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: CachedNetworkImage(
                            imageUrl: profileImage,
                            imageBuilder:
                                (context, imageProvider) => Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            placeholder: (_, __) => const Loader(),
                            errorWidget:
                                (_, __, ___) => CachedNetworkImage(
                                  imageUrl: ImageConstants.profileDefaultLogo,
                                  imageBuilder:
                                      (context, imageProvider) => Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                  placeholder: (_, __) => const Loader(),
                                  errorWidget:
                                      (_, __, ___) => const Icon(
                                        Icons.person,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text('Delicious Food', style: Style.text),
                const SizedBox(height: 2.0),
                Text('Discover and Get Great Food', style: Style.text2),
                const SizedBox(height: 15.0),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: GestureDetector(
                            onTap: () {
                              context.read<FoodBloc>().add(
                                FoodCardChanged(index),
                              );
                            },
                            child: BlocSelector<FoodBloc, FoodState, int>(
                              selector: (state) {
                                if (state is FoodSuccess) {
                                  return state.selectedIndex;
                                }
                                return 0;
                              },
                              builder: (context, selectedIndex) {
                                return Card(
                                  child: Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color:
                                          index == selectedIndex
                                              ? Colors.black
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.asset(
                                      images[index],
                                      color:
                                          index == selectedIndex
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 25.0),
                BlocConsumer<FoodBloc, FoodState>(
                  listener: (context, state) {
                    if (state is FoodFailure) {
                      showSnackBar(
                        context,
                        message: state.message,
                        color: Colors.red,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is FoodLoading) {
                      return const Loader();
                    } else if (state is FoodSuccess) {
                      final categories = state.categorizedFoods.keys.toList();
                      final category = categories[state.selectedIndex];
                      final foods = state.categorizedFoods[category] ?? [];

                      return Expanded(
                        child: ListView.builder(
                          itemCount: foods.length,
                          itemBuilder: (context, index) {
                            return FoodTile(food: foods[index]);
                          },
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
