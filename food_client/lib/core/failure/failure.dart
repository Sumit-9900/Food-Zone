import 'package:food_client/core/constants/text_constants.dart';

class AppFailure {
  final String message;
  const AppFailure([this.message = TextConstants.exception]);
}
