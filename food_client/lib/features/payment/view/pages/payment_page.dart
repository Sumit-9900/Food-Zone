import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/routes/route_constants.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/core/utils/show_snackbar.dart';
import 'package:food_client/core/widgets/button.dart';
import 'package:food_client/core/widgets/loader.dart';
import 'package:food_client/features/cart/models/address_model.dart';
import 'package:food_client/features/cart/viewmodel/cubit/address_cubit.dart';
import 'package:food_client/features/cart/viewmodel/cubit/cart_cubit.dart';
import 'package:food_client/features/food/models/food_model.dart';
import 'package:food_client/features/order/models/order_model.dart';
import 'package:food_client/features/order/viewmodel/bloc/order_bloc.dart';
import 'package:food_client/features/payment/enums/payment.dart';
import 'package:food_client/features/payment/view/widgets/payment_tile.dart';
import 'package:food_client/features/payment/viewmodel/cubit/payment_cubit.dart';
import 'package:go_router/go_router.dart';

class PaymentPage extends StatelessWidget {
  final double totalPrice;
  const PaymentPage({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final cartState = context.read<CartCubit>().state;
    final List<FoodModel> foods =
        cartState is CartProductFetched ? cartState.foods : [];
    final addressState = context.read<AddressCubit>().state;
    final List<AddressModel> addresses =
        addressState is AddressFetched ? addressState.addresses : [];
    final addressIndex =
        addressState is AddressFetched ? addressState.index : 0;
    final address = addresses[addressIndex];

    final paymentMethod = context.select<PaymentCubit, String>((cubit) {
      final paymentState = cubit.state;
      final payment =
          paymentState is PaymentChanged ? paymentState.payment : Payment.card;
      return paymentValues.reverse[payment] ?? '';
    });

    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (!context.mounted) return;
        if (state is PaymentFailure) {
          showSnackBar(context, message: state.message, color: Colors.red);
        } else if (state is PaymentSuccess) {
          context.read<OrderBloc>().add(
            OrderSent(
              isPaymentSuccessful: true,
              order: OrderModel(
                foods: foods,
                address: address,
                paymentMethod: paymentMethod,
                totalPrice: totalPrice,
                timestamp: Timestamp.now(),
              ),
            ),
          );
        }
      },
      child: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderFailure) {
            showSnackBar(context, message: state.message, color: Colors.red);
          } else if (state is OrderPlaced) {
            showSnackBar(
              context,
              message: 'Your food is orderred!',
              color: Colors.green,
            );
            context.pushNamed(
              RouteConstants.orderConfirmationRoute,
              extra: totalPrice,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Payment')),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Button(
                onPressed:
                    state is OrderLoading
                        ? () {}
                        : () {
                          context.read<PaymentCubit>().placeOrder(
                            totalPrice.toInt(),
                          );
                        },
                child:
                    state is OrderLoading
                        ? const Loader()
                        : Text('Place Order', style: Style.text3),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Payment Method',
                    style: Style.text2.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  PaymentTile(
                    icon: Icons.credit_card,
                    label: 'Credit/Debit Card',
                    payment: Payment.card,
                  ),
                  PaymentTile(
                    icon: Icons.attach_money,
                    label: 'Cash On Delivery',
                    payment: Payment.cod,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
