import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_client/core/constants/text_constants.dart';
import 'package:food_client/core/failure/failure.dart';
import 'package:food_client/features/food/models/food_model.dart';

abstract interface class FavoriteRemoteRepository {
  Stream<Either<AppFailure, List<String>>> fetchFavoriteFoods();
  Future<Either<AppFailure, void>> addFavorite(FoodModel food);
  Future<Either<AppFailure, void>> removeFavorite(String productId);
}

class FavoriteRemoteRepositoryImpl implements FavoriteRemoteRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  const FavoriteRemoteRepositoryImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Stream<Either<AppFailure, List<String>>> fetchFavoriteFoods() {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return Stream.value(left(AppFailure("User not logged in")));
      }

      final favoritesCollection = firestore
          .collection(TextConstants.productsCollection)
          .doc(uid)
          .collection(TextConstants.favoriteProductsCollection);

      return favoritesCollection
          .snapshots()
          .map((snapshot) {
            final foodIds = snapshot.docs.map((doc) => doc.id).toList();

            return right<AppFailure, List<String>>(foodIds);
          })
          .handleError((e) {
            return left<AppFailure, List<String>>(AppFailure(e.toString()));
          });
    } catch (e) {
      return Stream.value(left(AppFailure(e.toString())));
    }
  }

  @override
  Future<Either<AppFailure, void>> addFavorite(FoodModel food) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return left(AppFailure("User not logged in"));
      }

      await firestore
          .collection(TextConstants.productsCollection)
          .doc(uid)
          .collection(TextConstants.favoriteProductsCollection)
          .doc(food.productId)
          .set(food.toMap());

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> removeFavorite(String productId) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return left(AppFailure("User not logged in"));
      }

      await firestore
          .collection(TextConstants.productsCollection)
          .doc(uid)
          .collection(TextConstants.favoriteProductsCollection)
          .doc(productId)
          .delete();

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }
}
