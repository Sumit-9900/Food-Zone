import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_admin/core/constants/text_constants.dart';
import 'package:food_admin/core/routes/app_route_constants.dart';
import 'package:food_admin/features/food/models/food_model.dart';
import 'package:food_admin/features/food/viewmodel/bloc/food_bloc.dart';
import 'package:go_router/go_router.dart';

class FoodTile extends StatelessWidget {
  final FoodModel food;
  const FoodTile({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: CachedNetworkImageProvider(food.productImage),
        ),
        title: Text(food.productName),
        subtitle: Text('${TextConstants.indianRuppee}${food.productPrice}'),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  context.pushNamed(
                    AppRouteConstants.addNewFoodRouteName,
                    extra: food,
                  );
                },
                icon: const Icon(Icons.edit),
                color: Colors.blueGrey,
              ),
              IconButton(
                onPressed: () {
                  context.read<FoodBloc>().add(FoodDeleted(food.productId));
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
