import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_admin/core/theme/text_style.dart';
import 'package:food_admin/core/utils/show_snackbar.dart';
import 'package:food_admin/core/widgets/loader.dart';
import 'package:food_admin/features/order/viewmodel/bloc/order_bloc.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(OrderFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders', style: Style.text)),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderFailure) {
            showSnackBar(context, message: state.message, color: Colors.red);
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Loader();
          } else if (state is OrderSuccess) {
            final orders = state.orders;
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: ListView.separated(
                itemCount: orders.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Text(order.orderId, style: Style.text3);
                },
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
