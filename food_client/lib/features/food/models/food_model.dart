import 'dart:convert';

class FoodModel {
  final String productId;
  final String productName;
  final String productDetail;
  final String productImage;
  final String productPrice;
  final String productCategory;
  final int quantity;

  FoodModel({
    required this.productId,
    required this.productName,
    required this.productDetail,
    required this.productImage,
    required this.productPrice,
    required this.productCategory,
    this.quantity = 1,
  });

  FoodModel copyWith({
    String? productId,
    String? productName,
    String? productDetail,
    String? productImage,
    String? productPrice,
    String? productCategory,
    int? quantity,
  }) {
    return FoodModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productDetail: productDetail ?? this.productDetail,
      productImage: productImage ?? this.productImage,
      productPrice: productPrice ?? this.productPrice,
      productCategory: productCategory ?? this.productCategory,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'productName': productName,
      'productDetail': productDetail,
      'productImage': productImage,
      'productPrice': productPrice,
      'productCategory': productCategory,
      'quantity': quantity,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productDetail: map['productDetail'] ?? '',
      productImage: map['productImage'] ?? '',
      productPrice: map['productPrice'] ?? '',
      productCategory: map['productCategory'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) =>
      FoodModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FoodModel(productId: $productId, productName: $productName, productDetail: $productDetail, productImage: $productImage, productPrice: $productPrice, productCategory: $productCategory, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant FoodModel other) {
    if (identical(this, other)) return true;

    return other.productId == productId &&
        other.productName == productName &&
        other.productDetail == productDetail &&
        other.productImage == productImage &&
        other.productPrice == productPrice &&
        other.productCategory == productCategory &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        productName.hashCode ^
        productDetail.hashCode ^
        productImage.hashCode ^
        productPrice.hashCode ^
        productCategory.hashCode ^
        quantity.hashCode;
  }
}
