import 'package:flutter/material.dart';
import 'package:food_client/core/constants/text_constants.dart';
import 'package:food_client/core/utils/order_utils.dart';
import 'package:food_client/features/cart/view/widgets/order_summary_title.dart';
import 'package:food_client/features/food/models/food_model.dart';

class OrderSummaryCard extends StatelessWidget {
  final List<FoodModel> foods;
  const OrderSummaryCard({super.key, required this.foods});

  @override
  Widget build(BuildContext context) {
    final subTotal = OrderUtils.getSubtotal(foods);
    final tax = OrderUtils.getGST(subTotal);
    final shipping = OrderUtils.getDeliveryCharge(subTotal);
    final totalPrice = OrderUtils.getTotal(subTotal);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            OrderSummaryTitle(
              title: "Subtotal",
              value:
                  "${TextConstants.indianRuppee}${subTotal.toStringAsFixed(2)}",
            ),
            OrderSummaryTitle(
              title: "Shipping",
              value:
                  "${TextConstants.indianRuppee}${shipping.toStringAsFixed(2)}",
            ),
            OrderSummaryTitle(
              title: "Tax",
              value: "${TextConstants.indianRuppee}${tax.toStringAsFixed(2)}",
            ),
            Divider(),
            OrderSummaryTitle(
              title: "Total",
              value:
                  "${TextConstants.indianRuppee}${totalPrice.toStringAsFixed(2)}",
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}
