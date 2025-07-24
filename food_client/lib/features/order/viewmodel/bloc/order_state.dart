part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderFailure extends OrderState {
  final String message;
  OrderFailure(this.message);
}

final class OrderSuccess extends OrderState {
  final List<OrderModel> orders;
  OrderSuccess(this.orders);
}

final class OrderRemoved extends OrderState {}

final class OrderPlaced extends OrderState {}
