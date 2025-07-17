import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_client/core/constants/text_constants.dart';
import 'package:food_client/core/failure/failure.dart';

abstract interface class ProfileRemoteRepository {
  Future<Either<AppFailure, String>> uploadImageToFirebaseStorage(File file);
  Future<Either<AppFailure, void>> saveImageUrlToFirestore(String userImage);
  Future<Either<AppFailure, Map<String, dynamic>?>> fetchUserDetails();
  User? get currentUser;
}

class ProfileRemoteRepositoryImpl implements ProfileRemoteRepository {
  final FirebaseStorage storage;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const ProfileRemoteRepositoryImpl({
    required this.storage,
    required this.auth,
    required this.firestore,
  });

  @override
  Future<Either<AppFailure, String>> uploadImageToFirebaseStorage(
    File file,
  ) async {
    try {
      final taskSnapshot = await storage
          .ref()
          .child('profile-pic')
          .child(currentUser!.uid)
          .putFile(file);

      final imageUrl = await taskSnapshot.ref.getDownloadURL();

      return right(imageUrl);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> saveImageUrlToFirestore(
    String userImage,
  ) async {
    try {
      await firestore
          .collection(TextConstants.userDetailsCollection)
          .doc(currentUser?.uid)
          .update({'userImage': userImage});

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Map<String, dynamic>?>> fetchUserDetails() async {
    try {
      final snapshot =
          await firestore
              .collection(TextConstants.userDetailsCollection)
              .doc(currentUser?.uid)
              .get();

      final userData = snapshot.data();

      return right(userData);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  User? get currentUser => auth.currentUser;
}
