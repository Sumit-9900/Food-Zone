import 'package:food_client/core/utils/enum_values.dart';

enum OrderStatus { preparing, delivered }

final orderValues = EnumValues({
  'Preparing': OrderStatus.preparing,
  'Deliverred': OrderStatus.delivered,
});
