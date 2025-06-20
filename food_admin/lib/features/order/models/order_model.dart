import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final DateTime timestamp;
  OrderModel({required this.orderId, required this.timestamp});

  OrderModel copyWith({String? orderId, DateTime? timestamp}) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order_id': orderId,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['order_id'] ?? '',
      timestamp:
          map['timestamp'] is int
              ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
              : (map['timestamp'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OrderModel(orderId: $orderId, timestamp: $timestamp)';

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId && other.timestamp == timestamp;
  }

  @override
  int get hashCode => orderId.hashCode ^ timestamp.hashCode;
}
