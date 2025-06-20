part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

final class OrderFetched extends OrderEvent {}
