part of 'food_bloc.dart';

@immutable
sealed class FoodEvent {}

final class FoodFetched extends FoodEvent {}

final class FoodAdded extends FoodEvent {
  final File selectedImage;
  final String productDetail;
  final String productName;
  final String productPrice;

  FoodAdded({
    required this.selectedImage,
    required this.productDetail,
    required this.productName,
    required this.productPrice,
  });
}

class FoodDropdownChanged extends FoodEvent {
  final String dropdownValue;

  FoodDropdownChanged(this.dropdownValue);
}

class FoodDeleted extends FoodEvent {
  final String productId;
  FoodDeleted(this.productId);
}
