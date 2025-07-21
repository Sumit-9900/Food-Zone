import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/constants/text_constants.dart';
import 'package:food_client/core/routes/route_constants.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/core/utils/address.dart';
import 'package:food_client/features/cart/viewmodel/cubit/address_cubit.dart';
import 'package:food_client/features/cart/viewmodel/cubit/cart_cubit.dart';
import 'package:food_client/features/food/models/food_model.dart';
import 'package:food_client/features/payment/enums/payment.dart';
import 'package:food_client/features/payment/viewmodel/cubit/payment_cubit.dart';
import 'package:go_router/go_router.dart';

class OrderConfirmationPage extends StatelessWidget {
   final double totalPrice; 
  const OrderConfirmationPage({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final estimatedDeliveryTime = '30 minutes';

    return Scaffold(
      appBar: AppBar(title: Text('Order Confirmed 🎉')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.check_circle, size: 80, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text("Thank you for your order!", style: Style.text1),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text("Your food is being prepared.", style: Style.text2),
            ),
            const SizedBox(height: 24),

            Divider(),

            Text("🧾 Food Details", style: Style.text4),
            const SizedBox(height: 8),
            BlocSelector<CartCubit, CartState, List<FoodModel>>(
              selector: (state) {
                if (state is CartProductFetched) {
                  return state.foods;
                }
                return [];
              },
              builder: (context, foods) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(food.productName, style: Style.text9),
                      subtitle: Text(
                        "Qty: ${food.quantity}",
                        style: Style.text2,
                      ),
                      trailing: Text(
                        "₹${(double.parse(food.productPrice) * food.quantity).toStringAsFixed(2)}",
                        style: Style.text9,
                      ),
                    );
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: Style.text9.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${TextConstants.indianRuppee}${totalPrice.toStringAsFixed(2)}",
                    style: Style.text9,
                  ),
                ],
              ),
            ),
            Divider(),

            const SizedBox(height: 8),
            Text("💳 Payment Mode", style: Style.text4),
            const SizedBox(height: 4),
            BlocSelector<PaymentCubit, PaymentState, Payment>(
              selector: (state) {
                if (state is PaymentChanged) {
                  return state.payment;
                }
                return Payment.card;
              },
              builder: (context, selectedPayment) {
                final payment = paymentValues.reverse[selectedPayment] ?? '';
                return Text(payment, style: Style.text2);
              },
            ),
            Divider(),

            const SizedBox(height: 8),
            Text("📦 Shipping Details", style: Style.text4),
            const SizedBox(height: 4),
            BlocSelector<AddressCubit, AddressState, String>(
              selector: (state) {
                if (state is AddressFetched) {
                  final selectedIndex = state.index;
                  final address = state.addresses[selectedIndex];
                  final addressString = setAddress(address);
                  return addressString;
                }
                return '';
              },
              builder: (context, shippingAddress) {
                return Text(shippingAddress, style: Style.text2);
              },
            ),
            Divider(),

            const SizedBox(height: 8),
            Text("⏰ Estimated Delivery", style: Style.text4),
            const SizedBox(height: 4),
            Text(estimatedDeliveryTime, style: Style.text2),

            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      context.pushNamed(RouteConstants.orderRoute);
                    },
                    child: Text(
                      'Track Your Food',
                      style: Style.text3.copyWith(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    onPressed: () {
                      context.goNamed(RouteConstants.bottomNavRoute);
                    },
                    child: Text(
                      'Explore More',
                      style: Style.text9.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
