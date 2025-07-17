import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_client/core/constants/text_constants.dart';
import 'package:food_client/core/failure/failure.dart';

abstract interface class AuthRemoteRepository {
  Future<Either<AppFailure, User>> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<AppFailure, User>> logIn({
    required String email,
    required String password,
  });
  Future<Either<AppFailure, void>> forgotPassword(String email);
  Future<Either<AppFailure, void>> logOut();
  Future<Either<AppFailure, void>> deleteUser(String userImage);
  Future<Either<AppFailure, void>> storeUserDetailsToFirestore({
    required String name,
    required String email,
  });
  User? getCurrentUser();
}

class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  const AuthRemoteRepositoryImpl({
    required this.auth,
    required this.firestore,
    required this.storage,
  });

  @override
  User? getCurrentUser() => auth.currentUser;

  @override
  Future<Either<AppFailure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return left(AppFailure('No user found!'));
      }

      final data = await storeUserDetailsToFirestore(name: name, email: email);

      return data.fold(
        (failure) => left(failure),
        (_) => right(userCredential.user!),
      );
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, User>> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return left(AppFailure('No user found!'));
      }

      return right(userCredential.user!);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> forgotPassword(String email) async {
    try {
      final querySnapshot =
          await firestore
              .collection(TextConstants.userDetailsCollection)
              .where('email', isEqualTo: email.trim().toLowerCase())
              .limit(1)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return left(AppFailure('Email not found in our records!'));
      }

      await auth.sendPasswordResetEmail(email: email);

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> logOut() async {
    try {
      await auth.signOut();

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteUser(String userImage) async {
    try {
      // User Firebase Storage Image deletion
      if (userImage.isNotEmpty) {
        await storage
            .ref()
            .child(TextConstants.userImageCollection)
            .child(getCurrentUser()!.uid)
            .delete();
      }

      // User Firestore data deletion
      await firestore
          .collection(TextConstants.userDetailsCollection)
          .doc(getCurrentUser()?.uid)
          .delete();
      // User auth deletion
      await getCurrentUser()?.delete();

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> storeUserDetailsToFirestore({
    required String name,
    required String email,
  }) async {
    try {
      await firestore
          .collection(TextConstants.userDetailsCollection)
          .doc(getCurrentUser()?.uid)
          .set({
            'userId': getCurrentUser()?.uid,
            'username': name,
            'email': email,
            'userImage': '',
          });

      return right(null);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }
}
