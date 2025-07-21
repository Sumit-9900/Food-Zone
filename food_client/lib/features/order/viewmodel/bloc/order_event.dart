part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

final class OrderSent extends OrderEvent {
  final bool isPaymentSuccessful;
  final OrderModel order;
  OrderSent({required this.isPaymentSuccessful, required this.order});
}

final class OrderFetched extends OrderEvent {}

final class OrderDeleted extends OrderEvent {
  final String docId;
  OrderDeleted(this.docId);
}
