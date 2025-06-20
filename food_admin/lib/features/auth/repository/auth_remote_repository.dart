import 'package:dartz/dartz.dart';
import 'package:food_admin/core/constants/text_constants.dart';
import 'package:food_admin/core/failure/app_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_admin/features/auth/models/user_model.dart';

abstract interface class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> login({
    required String username,
    required String password,
  });
}

class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  final FirebaseFirestore firestore;

  const AuthRemoteRepositoryImpl({required this.firestore});

  @override
  Future<Either<AppFailure, UserModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      final querySnapshot =
          await firestore.collection(TextConstants.adminCollection).get();

      final username = querySnapshot.docs[0]['username'];
      final password = querySnapshot.docs[0]['password'];

      final user = UserModel(username: username, password: password);

      return right(user);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }
}
