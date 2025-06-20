import 'package:dartz/dartz.dart';
import 'package:food_admin/core/constants/text_constants.dart';
import 'package:food_admin/core/failure/app_failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalRepository {
  Future<Either<AppFailure, bool>> setIsLoggedIn(bool isLoggedIn);
  bool getIsLoggedIn();
  Future<Either<AppFailure, bool>> logOut();
}

class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final SharedPreferences prefs;
  const AuthLocalRepositoryImpl(this.prefs);

  @override
  Future<Either<AppFailure, bool>> setIsLoggedIn(bool isLoggedIn) async {
    try {
      final setData = await prefs.setBool(
        TextConstants.isLoggedInKey,
        isLoggedIn,
      );

      return right(setData);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }

  @override
  bool getIsLoggedIn() {
    return prefs.getBool(TextConstants.isLoggedInKey) ?? false;
  }

  @override
  Future<Either<AppFailure, bool>> logOut() async {
    try {
      final isLogOut = await prefs.clear();
      return right(isLogOut);
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }
}
