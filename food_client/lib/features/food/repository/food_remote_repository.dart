import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_client/core/failure/failure.dart';
import 'package:food_client/features/food/models/food_model.dart';

abstract interface class FoodRemoteRepository {
  Future<Either<AppFailure, List<FoodModel>>> fetchFoods();
}

class FoodRemoteRepositoryImpl implements FoodRemoteRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  const FoodRemoteRepositoryImpl({required this.firestore, required this.auth});

  @override
  Future<Either<AppFailure, List<FoodModel>>> fetchFoods() async {
    try {
      final querySnapshot = await firestore.collection('product-details').get();

      final foods =
          querySnapshot.docs
              .map((doc) => FoodModel.fromMap(doc.data()))
              .toList();

      return right(foods);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }


}
