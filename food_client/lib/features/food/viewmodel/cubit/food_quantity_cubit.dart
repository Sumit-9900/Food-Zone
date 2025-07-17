import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'food_quantity_state.dart';

class FoodQuantityCubit extends Cubit<FoodQuantityState> {
  FoodQuantityCubit() : super(FoodQuantityChanged(1));

  void incrementQnty() {
    if (state is FoodQuantityChanged) {
      int currentQuantity = (state as FoodQuantityChanged).qnty;
      emit(FoodQuantityChanged(currentQuantity + 1));
    }
  }

  void decrementQnty() {
    if (state is FoodQuantityChanged) {
      int currentQuantity = (state as FoodQuantityChanged).qnty;
      if (currentQuantity > 1) {
        emit(FoodQuantityChanged(currentQuantity - 1));
      }
    }
  }
}
