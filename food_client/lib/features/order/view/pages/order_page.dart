import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/core/utils/show_snackbar.dart';
import 'package:food_client/core/widgets/loader.dart';
import 'package:food_client/features/order/view/widgets/order_tile.dart';
import 'package:food_client/features/order/viewmodel/bloc/order_bloc.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderFailure) {
            showSnackBar(context, message: state.message, color: Colors.red);
          } else if (state is OrderRemoved) {
            showSnackBar(
              context,
              message: 'Order removed successfully!',
              color: Colors.green,
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Loader();
          } else if (state is OrderSuccess) {
            final orders = state.orders;

            return orders.isEmpty
                ? Center(
                  child: Text(
                    'No Orders are present!',
                    style: Style.text2.copyWith(fontSize: 22.0),
                  ),
                )
                : ListView.separated(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return OrderTile(order: order);
                  },
                );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
