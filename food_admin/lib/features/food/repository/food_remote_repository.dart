import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:food_admin/core/constants/text_constants.dart';
import 'package:food_admin/core/failure/app_failure.dart';
import 'package:food_admin/features/food/models/food_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class FoodRemoteRepository {
  Future<Either<AppFailure, List<FoodModel>>> getAllFoods();
  Future<Either<AppFailure, FoodModel>> sendFoodDataToFirestore({
    required File selectedImage,
    required String productCategory,
    required String productDetail,
    required String productName,
    required String productPrice,
  });
  Future<Either<AppFailure, void>> deleteFood(String productId);
  Future<Either<AppFailure, void>> editFood({
    required String productId,
    required File? selectedImage,
    required String image,
    required String productCategory,
    required String productDetail,
    required String productName,
    required String productPrice,
  });
}

class FoodRemoteRepositoryImpl implements FoodRemoteRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  const FoodRemoteRepositoryImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<Either<AppFailure, List<FoodModel>>> getAllFoods() async {
    try {
      final querySnapshot =
          await firestore.collection(TextConstants.productsCollection).get();

      final foods =
          querySnapshot.docs
              .map((doc) => FoodModel.fromMap(doc.data()))
              .toList();

      return right(foods);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, FoodModel>> sendFoodDataToFirestore({
    required File selectedImage,
    required String productCategory,
    required String productDetail,
    required String productName,
    required String productPrice,
  }) async {
    try {
      final id = const Uuid().v4();
      final taskSnapshot = await storage
          .ref()
          .child(TextConstants.productImageCollection)
          .child(id)
          .putFile(selectedImage);

      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      final food = FoodModel(
        productCategory: productCategory,
        productDetail: productDetail,
        productId: id,
        productImage: downloadUrl,
        productName: productName,
        productPrice: productPrice,
      );

      debugPrint('Food: $food');

      await firestore
          .collection(TextConstants.productsCollection)
          .add(food.toMap());

      return right(food);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteFood(String productId) async {
    try {
      final querySnapshot =
          await firestore
              .collection(TextConstants.productsCollection)
              .where('productId', isEqualTo: productId)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return left(AppFailure("No product found with productId: $productId"));
      }

      await storage
          .ref()
          .child(TextConstants.productImageCollection)
          .child(productId)
          .delete();

      await querySnapshot.docs.first.reference.delete();

      return right(null);
    } catch (e) {
      throw left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> editFood({
    required String productId,
    required File? selectedImage,
    required String image,
    required String productCategory,
    required String productDetail,
    required String productName,
    required String productPrice,
  }) async {
    try {
      final querySnapshot =
          await firestore
              .collection(TextConstants.productsCollection)
              .where('productId', isEqualTo: productId)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return left(AppFailure("No product found with productId: $productId}"));
      }

      String? downloadUrl;

      if (selectedImage != null) {
        final taskSnapshot = await storage
            .ref()
            .child(TextConstants.productImageCollection)
            .child(productId)
            .putFile(selectedImage);

        downloadUrl = await taskSnapshot.ref.getDownloadURL();
      }

      final food = FoodModel(
        productCategory: productCategory,
        productDetail: productDetail,
        productId: productId,
        productImage: downloadUrl ?? image,
        productName: productName,
        productPrice: productPrice,
      );

      await querySnapshot.docs.first.reference.update(food.toMap());

      return right(null);
    } catch (e) {
      throw left(AppFailure(e.toString()));
    }
  }
}
