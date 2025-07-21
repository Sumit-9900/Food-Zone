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

final class FoodDropdownChanged extends FoodEvent {
  final String dropdownValue;

  FoodDropdownChanged(this.dropdownValue);
}

final class FoodDeleted extends FoodEvent {
  final String productId;
  FoodDeleted(this.productId);
}

final class FoodEdited extends FoodEvent {
  final String productId;
  final File? selectedImage;
  final String? image;
  final String productCategory;
  final String productDetail;
  final String productName;
  final String productPrice;

  FoodEdited({
    required this.productId,
    required this.selectedImage,
    required this.image,
    required this.productCategory,
    required this.productDetail,
    required this.productName,
    required this.productPrice,
  });
}
