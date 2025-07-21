import 'package:food_client/core/utils/enum_values.dart';

enum Payment { card, cod }

final paymentValues = EnumValues({
  "Credit/Debit Card": Payment.card,
  "Cash on Delivery": Payment.cod,
});
