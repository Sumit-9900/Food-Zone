import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_admin/core/constants/text_constants.dart';
import 'package:food_admin/core/failure/app_failure.dart';
import 'package:food_admin/features/order/models/order_model.dart';

abstract interface class OrderRemoteRepository {
  Future<Either<AppFailure, List<OrderModel>>> fetchOrders();
}

class OrderRemoteRepositoryImpl implements OrderRemoteRepository {
  final FirebaseFirestore firestore;
  const OrderRemoteRepositoryImpl({required this.firestore});

  @override
  Future<Either<AppFailure, List<OrderModel>>> fetchOrders() async {
    try {
      final querySnapshot =
          await firestore.collection(TextConstants.ordersCollection).get();

      final orders =
          querySnapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data()))
              .toList();

      return right(orders);
    } catch (e) {
      throw left(AppFailure(e.toString()));
    }
  }
}
