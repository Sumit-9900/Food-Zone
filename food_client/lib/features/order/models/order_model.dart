import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:food_client/features/cart/models/address_model.dart';
import 'package:food_client/features/food/models/food_model.dart';
import 'package:food_client/features/order/enums/order.dart';

class OrderModel {
  final String? id;
  final List<FoodModel> foods;
  final AddressModel address;
  final String paymentMethod;
  final OrderStatus orderStatus;
  final double totalPrice;
  final Timestamp timestamp; // 🆕 Added

  OrderModel({
    this.id,
    required this.foods,
    required this.address,
    required this.paymentMethod,
    this.orderStatus = OrderStatus.preparing,
    required this.totalPrice,
    Timestamp? timestamp,
  }) : timestamp = timestamp ?? Timestamp.now(); // default to now

  OrderModel copyWith({
    String? id,
    List<FoodModel>? foods,
    AddressModel? address,
    String? paymentMethod,
    OrderStatus? orderStatus,
    double? totalPrice,
    Timestamp? timestamp,
  }) {
    return OrderModel(
      id: id ?? this.id,
      foods: foods ?? this.foods,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderStatus: orderStatus ?? this.orderStatus,
      totalPrice: totalPrice ?? this.totalPrice,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'foods': foods.map((x) => x.toMap()).toList(),
      'address': address.toMap(),
      'paymentMethod': paymentMethod,
      'orderStatus': orderValues.reverse[orderStatus],
      'totalPrice': totalPrice,
      'timestamp': timestamp, // 🆕 Add to map
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      id: docId,
      foods: List<FoodModel>.from(
        (map['foods'] ?? []).map<FoodModel>(
          (x) => FoodModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      address: AddressModel.fromMap(map['address'] ?? {}, ''),
      paymentMethod: map['paymentMethod'] ?? '',
      orderStatus: orderValues.map[map['orderStatus']] ?? OrderStatus.preparing,
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      timestamp: map['timestamp'] ?? Timestamp.now(), // 🆕 Handle null safely
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source, String docId) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>, docId);

  @override
  String toString() {
    return 'OrderModel(id: $id, foods: $foods, address: $address, paymentMethod: $paymentMethod, orderStatus: $orderStatus, totalPrice: $totalPrice, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.foods, foods) &&
        other.id == id &&
        other.address == address &&
        other.paymentMethod == paymentMethod &&
        other.orderStatus == orderStatus &&
        other.totalPrice == totalPrice &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return foods.hashCode ^
        id.hashCode ^
        address.hashCode ^
        paymentMethod.hashCode ^
        orderStatus.hashCode ^
        totalPrice.hashCode ^
        timestamp.hashCode;
  }
}
