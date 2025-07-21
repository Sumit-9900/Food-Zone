import 'package:food_client/features/cart/models/address_model.dart';

String setAddress(AddressModel address) {
  return '${address.addressLine1}, '
      '${address.addressLine2 != null && address.addressLine2!.isNotEmpty ? '${address.addressLine2}, ' : ''}'
      '${address.city}, '
      '${address.postalCode}';
}
