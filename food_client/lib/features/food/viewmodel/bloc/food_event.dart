part of 'food_bloc.dart';

@immutable
sealed class FoodEvent {}

final class FoodCardChanged extends FoodEvent {
  final int index;
  FoodCardChanged(this.index);
}

final class FoodFetched extends FoodEvent {}

final class UserFetched extends FoodEvent {}
