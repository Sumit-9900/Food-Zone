part of 'food_quantity_cubit.dart';

@immutable
sealed class FoodQuantityState {}

final class FoodQuantityChanged extends FoodQuantityState {
  final int qnty;
  FoodQuantityChanged(this.qnty);
}
