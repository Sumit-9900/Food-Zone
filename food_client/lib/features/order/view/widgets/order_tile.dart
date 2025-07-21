import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/utils/address.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/features/order/models/order_model.dart';
import 'package:food_client/features/order/viewmodel/bloc/order_bloc.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;
  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final foodSummary = order.foods.map((e) => e.productName).join(', ');
    final totalPrice = order.totalPrice;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🍱 Food Name Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.fastfood, color: Colors.deepOrange, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    foodSummary,
                    style: Style.text9.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 💰 Items and Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.foods.length} item${order.foods.length > 1 ? 's' : ''}',
                  style: Style.text9.copyWith(color: Colors.grey[700]),
                ),
                Text(
                  '₹${totalPrice.toStringAsFixed(2)}',
                  style: Style.text9.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// 🏠 Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.green, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    setAddress(order.address),
                    style: Style.text9.copyWith(color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// ⏰ ETA
            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  'Delivery in 30 minutes',
                  style: Style.text9.copyWith(color: Colors.blueGrey),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 💳 Payment
            Row(
              children: [
                const Icon(Icons.payment, size: 18, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(
                  order.paymentMethod,
                  style: Style.text9.copyWith(color: Colors.indigo),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<OrderBloc>().add(OrderDeleted(order.id!));
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
