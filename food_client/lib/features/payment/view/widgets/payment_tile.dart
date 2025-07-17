import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/theme/textstyle.dart';
import 'package:food_client/features/payment/viewmodel/cubit/payment_cubit.dart';

class PaymentTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Payment payment;
  const PaymentTile({
    super.key,
    required this.label,
    required this.icon,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PaymentCubit, PaymentState, Payment>(
      selector: (state) {
        if (state is PaymentChanged) {
          return state.payment;
        }
        return Payment.card;
      },
      builder: (context, selectedPayment) {
        final isSelected = selectedPayment == payment;

        return GestureDetector(
          onTap: () {
            context.read<PaymentCubit>().paymentTileChanged(payment);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? Colors.black : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, color: isSelected ? Colors.black : Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: Style.text2.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Colors.black),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
