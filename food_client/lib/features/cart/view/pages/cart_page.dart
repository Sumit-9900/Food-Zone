import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/routes/route_constants.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/core/utils/order_utils.dart';
import 'package:food_client/core/utils/show_snackbar.dart';
import 'package:food_client/core/widgets/button.dart';
import 'package:food_client/core/widgets/loader.dart';
import 'package:food_client/features/cart/view/widgets/cart_product_tile.dart';
import 'package:food_client/features/cart/view/widgets/order_summary_card.dart';
import 'package:food_client/features/cart/viewmodel/cubit/cart_cubit.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Cart'),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(RouteConstants.orderRoute);
            },
            icon: Icon(Icons.shopping_bag),
          ),
        ],
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocConsumer<CartCubit, CartState>(
            listener: (context, state) {
              if (state is CartFailure) {
                showSnackBar(
                  context,
                  message: state.message,
                  color: Colors.red,
                );
              }
            },
            builder: (context, state) {
              if (state is CartLoading) {
                return const Loader();
              } else if (state is CartProductFetched) {
                final foods = state.foods;
                final subTotal = OrderUtils.getSubtotal(foods);
                final totalPrice = OrderUtils.getTotal(subTotal);

                if (foods.isEmpty) {
                  return Center(
                    child: Text(
                      'No food added to cart!',
                      style: Style.text2.copyWith(fontSize: 22.0),
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: foods.length,
                        itemBuilder: (context, index) {
                          final food = foods[index];
                          return CartProductTile(food: food);
                        },
                      ),
                    ),
                    OrderSummaryCard(foods: foods),
                    Button(
                      label: 'Place Order',
                      onPressed: () {
                        context.pushNamed(
                          RouteConstants.shippingRoute,
                          extra: totalPrice,
                        );
                      },
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
