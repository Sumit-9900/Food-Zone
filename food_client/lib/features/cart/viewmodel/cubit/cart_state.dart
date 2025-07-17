part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartFailure extends CartState {
  final String message;
  CartFailure(this.message);
}

final class CartProductAdded extends CartState {}

final class CartProductFetched extends CartState {
  final List<FoodModel> foods;
  CartProductFetched(this.foods);
}
