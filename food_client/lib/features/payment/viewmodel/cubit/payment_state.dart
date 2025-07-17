part of 'payment_cubit.dart';

@immutable
sealed class PaymentState {}

final class PaymentChanged extends PaymentState {
  final Payment payment;
  PaymentChanged(this.payment);
}

final class PaymentFailure extends PaymentState {
  final String message;
  PaymentFailure(this.message);
}

final class PaymentSuccess extends PaymentState {
  final String message;
  PaymentSuccess(this.message);
}
