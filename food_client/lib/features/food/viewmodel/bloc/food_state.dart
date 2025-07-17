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
  final UserModel user;
  final int selectedIndex;
  final Map<String, List<FoodModel>> categorizedFoods;
  final List<FoodModel> allFoods;

  FoodSuccess({
    required this.user,
    required this.selectedIndex,
    required this.categorizedFoods,
    required this.allFoods,
  });

  FoodSuccess copyWith({
    UserModel? user,
    Map<String, List<FoodModel>>? categorizedFoods,
    int? selectedIndex,
    List<FoodModel>? allFoods,
  }) {
    return FoodSuccess(
      user: user ?? this.user,
      categorizedFoods: categorizedFoods ?? this.categorizedFoods,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      allFoods: allFoods ?? this.allFoods,
    );
  }
}
