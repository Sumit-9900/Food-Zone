import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_client/core/constants/text_constants.dart';
import 'package:food_client/core/failure/failure.dart';
import 'package:food_client/features/order/models/order_model.dart';
import 'package:http/http.dart' as http;

abstract interface class OrderRemoteRepository {
  Future<Either<AppFailure, void>> storeOrdersToFirestore(OrderModel order);
  Future<Either<AppFailure, List<OrderModel>>> fetchOrders();
  Future<Either<AppFailure, void>> deleteOrder(String docId);
}

class OrderRemoteRepositoryImpl implements OrderRemoteRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final http.Client httpClient;
  const OrderRemoteRepositoryImpl({
    required this.firestore,
    required this.auth,
    required this.httpClient,
  });

  @override
  Future<Either<AppFailure, void>> storeOrdersToFirestore(
    OrderModel order,
  ) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return left(AppFailure("User not logged in"));
      }

      await firestore
          .collection(TextConstants.productsCollection)
          .doc(uid)
          .collection(TextConstants.userOrdersCollection)
          .add(order.toMap());

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<OrderModel>>> fetchOrders() async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return left(AppFailure("User not logged in"));
      }

      final querySnapshot =
          await firestore
              .collection(TextConstants.productsCollection)
              .doc(uid)
              .collection(TextConstants.userOrdersCollection)
              .orderBy('timestamp', descending: true)
              .get();

      final orderredFoods =
          querySnapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
              .toList();

      return right(orderredFoods);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteOrder(String docId) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return left(AppFailure("User not logged in"));
      }

      await firestore
          .collection(TextConstants.productsCollection)
          .doc(uid)
          .collection(TextConstants.userOrdersCollection)
          .doc(docId)
          .delete();

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }
}
