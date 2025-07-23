part of 'food_bloc.dart';

@immutable
sealed class FoodState {}

final class FoodInitial extends FoodState {}

final class FoodLoading extends FoodState {}

final class FoodFailure extends FoodState {
  final String message;
  FoodFailure(this.message);
}

final class FoodSuccess extends FoodState {
  final List<FoodModel> foods;
  FoodSuccess(this.foods);
}

final class FoodAddedSuccess extends FoodState {}

final class FoodDeletedSuccess extends FoodState {}

final class FoodEditedSuccess extends FoodState {}

final class FoodEditCancelled extends FoodState {}

class FoodCategoryChanged extends FoodState {
  final String selectedCategory;
  FoodCategoryChanged(this.selectedCategory);
}
