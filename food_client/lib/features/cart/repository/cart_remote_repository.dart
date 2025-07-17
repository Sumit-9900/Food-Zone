import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_client/core/constants/text_constants.dart';
import 'package:food_client/core/failure/failure.dart';
import 'package:food_client/features/cart/models/address_model.dart';
import 'package:food_client/features/food/models/food_model.dart';

abstract interface class CartRemoteRepository {
  Future<Either<AppFailure, void>> addProductToCart(
    FoodModel food,
    int quantity,
  );
  Stream<Either<AppFailure, List<FoodModel>>> fetchCartProducts();
  Future<Either<AppFailure, void>> deleteCartProduct(String productId);
  Future<Either<AppFailure, bool>> saveAddress(AddressModel address);
  Future<Either<AppFailure, List<AddressModel>>> getUserSavedAddresses();
  Future<Either<AppFailure, void>> deleteUserAddress(String docId);
  Future<Either<AppFailure, bool>> editUserAddress(AddressModel address);
}

class CartRemoteRepositoryImpl implements CartRemoteRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  CartRemoteRepositoryImpl({required this.firestore, required this.auth});

  @override
  Future<Either<AppFailure, void>> addProductToCart(
    FoodModel food,
    int quantity,
  ) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return left(AppFailure("User not logged in"));
      }

      final cartRef = firestore
          .collection(TextConstants.productsCollection)
          .doc(uid)
          .collection(TextConstants.cartProductsCollection)
          .doc(food.productId);

      final documentSnapshot = await cartRef.get();

      int newQuantity = quantity;

      if (documentSnapshot.exists) {
        final mappedData = documentSnapshot.data();
        final existingQuantity = (mappedData?['quantity'] ?? 0) as int;
        newQuantity += existingQuantity;
      }

      final foodMap = food.toMap();
      foodMap['quantity'] = newQuantity;

      await cartRef.set(foodMap);

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Stream<Either<AppFailure, List<FoodModel>>> fetchCartProducts() {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return Stream.value(left(AppFailure("User not logged in")));
      }

      final cartsCollection = firestore
          .collection(TextConstants.productsCollection)
          .doc(uid)
          .collection(TextConstants.cartProductsCollection);

      return cartsCollection
          .snapshots()
          .map((snapshot) {
            final foods =
                snapshot.docs
                    .map((doc) => FoodModel.fromMap(doc.data()))
                    .toList();

            return right<AppFailure, List<FoodModel>>(foods);
          })
          .handleError((e) {
            return left<AppFailure, List<FoodModel>>(AppFailure(e.toString()));
          });
    } catch (e) {
      return Stream.value(left(AppFailure(e.toString())));
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteCartProduct(String productId) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return left(AppFailure("User not logged in"));
      }

      await firestore
          .collection(TextConstants.productsCollection)
          .doc(uid)
          .collection(TextConstants.cartProductsCollection)
          .doc(productId)
          .delete();

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, bool>> saveAddress(AddressModel address) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return left(AppFailure("User not logged in"));
      }

      final querySnapshot =
          await firestore
              .collection(TextConstants.productsCollection)
              .doc(uid)
              .collection(TextConstants.userAddressCollection)
              .get();

      final existing = querySnapshot.docs.where((doc) {
        final data = doc.data();

        final String addressLine1 = data['addressLine1'] ?? '';
        final String addressLine2 = data['addressLine2'] ?? '';

        return addressLine1 == address.addressLine1 &&
            addressLine2 == address.addressLine2;
      });

      if (existing.isNotEmpty) {
        return right(true);
      }

      await firestore
          .collection(TextConstants.productsCollection)
          .doc(uid)
          .collection(TextConstants.userAddressCollection)
          .add(address.toMap());

      return right(false);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<AddressModel>>> getUserSavedAddresses() async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return left(AppFailure("User not logged in"));
      }

      final querySnapshot =
          await firestore
              .collection(TextConstants.productsCollection)
              .doc(uid)
              .collection(TextConstants.userAddressCollection)
              .get();

      final addresses =
          querySnapshot.docs
              .map((doc) => AddressModel.fromMap(doc.data(), doc.id))
              .toList();

      return right(addresses);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteUserAddress(String docId) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return left(AppFailure("User not logged in"));
      }

      await firestore
          .collection(TextConstants.productsCollection)
          .doc(uid)
          .collection(TextConstants.userAddressCollection)
          .doc(docId)
          .delete();

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, bool>> editUserAddress(AddressModel address) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return left(AppFailure("User not logged in"));
      }

      final querySnapshot =
          await firestore
              .collection(TextConstants.productsCollection)
              .doc(uid)
              .collection(TextConstants.userAddressCollection)
              .get();

      final existing = querySnapshot.docs.where((doc) {
        final data = doc.data();

        final String addressLine1 = data['addressLine1'] ?? '';
        final String addressLine2 = data['addressLine2'] ?? '';

        return addressLine1 == address.addressLine1 &&
            addressLine2 == address.addressLine2;
      });

      if (existing.isNotEmpty) {
        return right(true);
      }

      await firestore
          .collection(TextConstants.productsCollection)
          .doc(uid)
          .collection(TextConstants.userAddressCollection)
          .doc(address.id)
          .update(address.toMap());

      return right(false);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }
}
