import 'package:food_client/features/food/models/food_model.dart';

class OrderUtils {
  // Shipping is free for orders above ₹1000
  static const double flatDeliveryCharge = 70.0;
  static const double freeDeliveryThreshold = 1000.0;

  // Assuming 5% GST applicable on food
  static const double gstRate = 0.05;

  // Subtotal calculation
  static double getSubtotal(List<FoodModel> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + (double.parse(item.productPrice) * item.quantity),
    );
  }

  // GST Calculation
  static double getGST(double subtotal) {
    return subtotal * gstRate;
  }

  // Delivery charge (₹70 if below threshold)
  static double getDeliveryCharge(double subtotal) {
    return subtotal >= freeDeliveryThreshold ? 0.0 : flatDeliveryCharge;
  }

  // Total = Subtotal + GST + Delivery
  static double getTotal(double subtotal) {
    return subtotal + getGST(subtotal) + getDeliveryCharge(subtotal);
  }
}
