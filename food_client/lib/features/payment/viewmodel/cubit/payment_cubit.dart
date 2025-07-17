import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/features/payment/repository/payment_remote_repository.dart';

part 'payment_state.dart';

enum Payment { card, cod }

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRemoteRepository _paymentRemoteRepository;
  PaymentCubit({required PaymentRemoteRepository paymentRemoteRepository})
    : _paymentRemoteRepository = paymentRemoteRepository,
      super(PaymentChanged(Payment.card));

  Map<String, dynamic>? data;
  Payment _currentPayment = Payment.card;

  void paymentTileChanged(Payment payment) {
    _currentPayment = payment;
    emit(PaymentChanged(payment));
  }

  void placeOrder(int amount) async {
    final paymentOption = _currentPayment;

    if (paymentOption == Payment.card) {
      final paymentIntentRes = await _paymentRemoteRepository
          .createPaymentIntent(amount);

      if (paymentIntentRes.isLeft()) {
        emit(
          PaymentFailure(paymentIntentRes.fold((l) => l.message, (_) => '')),
        );
        data = null;
        return;
      }

      data = paymentIntentRes.getOrElse(() => {});
      final clientSecret = data!['client_secret'] as String;

      final initSheetRes = await _paymentRemoteRepository.initPaymentSheet(
        clientSecret,
      );

      if (initSheetRes.isLeft()) {
        emit(PaymentFailure(initSheetRes.fold((l) => l.message, (_) => '')));
        data = null;
        return;
      }

      final presentSheetRes =
          await _paymentRemoteRepository.presentPaymentSheet();

      if (presentSheetRes.isLeft()) {
        emit(PaymentFailure(presentSheetRes.fold((l) => l.message, (_) => '')));
        data = null;
        return;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      emit(PaymentSuccess("Payment successful!"));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(PaymentChanged(_currentPayment));
      data = null;
    } else if (paymentOption == Payment.cod) {
      // Directly emit success for COD
      emit(PaymentSuccess("Order placed with Cash on Delivery!"));
      emit(PaymentChanged(_currentPayment));
    }
  }
}
