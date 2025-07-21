import 'dart:convert';

class FoodModel {
  final String productCategory;
  final String productDetail;
  final String productId;
  final String productImage;
  final String productName;
  final String productPrice;
  const FoodModel({
    required this.productCategory,
    required this.productDetail,
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productPrice,
  });

  FoodModel copyWith({
    String? productCategory,
    String? productDetail,
    String? productId,
    String? productImage,
    String? productName,
    String? productPrice,
  }) {
    return FoodModel(
      productCategory: productCategory ?? this.productCategory,
      productDetail: productDetail ?? this.productDetail,
      productId: productId ?? this.productId,
      productImage: productImage ?? this.productImage,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productCategory': productCategory,
      'productDetail': productDetail,
      'productId': productId,
      'productImage': productImage,
      'productName': productName,
      'productPrice': productPrice,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      productCategory: map['productCategory'] ?? '',
      productDetail: map['productDetail'] ?? '',
      productId: map['productId'] ?? '',
      productImage: map['productImage'] ?? '',
      productName: map['productName'] ?? '',
      productPrice: map['productPrice'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) =>
      FoodModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FoodModel(productCategory: $productCategory, productDetail: $productDetail, productId: $productId, productImage: $productImage, productName: $productName, productPrice: $productPrice)';
  }

  @override
  bool operator ==(covariant FoodModel other) {
    if (identical(this, other)) return true;

    return other.productCategory == productCategory &&
        other.productDetail == productDetail &&
        other.productId == productId &&
        other.productImage == productImage &&
        other.productName == productName &&
        other.productPrice == productPrice;
  }

  @override
  int get hashCode {
    return productCategory.hashCode ^
        productDetail.hashCode ^
        productId.hashCode ^
        productImage.hashCode ^
        productName.hashCode ^
        productPrice.hashCode;
  }
}
