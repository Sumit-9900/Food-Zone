import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/core/utils/show_snackbar.dart';
import 'package:food_client/core/widgets/button.dart';
import 'package:food_client/features/payment/view/widgets/payment_tile.dart';
import 'package:food_client/features/payment/viewmodel/cubit/payment_cubit.dart';

class PaymentPage extends StatelessWidget {
  final double totalPrice;
  const PaymentPage({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (!context.mounted) return;
        if (state is PaymentFailure) {
          showSnackBar(context, message: state.message, color: Colors.red);
        } else if (state is PaymentSuccess) {
          showSnackBar(context, message: state.message, color: Colors.green);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Button(
            onPressed: () {
              context.read<PaymentCubit>().placeOrder(totalPrice.toInt());
            },
            child: Text('Place Order', style: Style.text3),
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
      ),
    );
  }
}
