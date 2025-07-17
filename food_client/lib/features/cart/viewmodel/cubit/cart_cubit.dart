import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/failure/failure.dart';
import 'package:food_client/features/cart/repository/cart_remote_repository.dart';
import 'package:food_client/features/food/models/food_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRemoteRepository _cartRemoteRepository;
  StreamSubscription<Either<AppFailure, List<FoodModel>>>? _cartSubscription;
  CartCubit({required CartRemoteRepository cartRemoteRepository})
    : _cartRemoteRepository = cartRemoteRepository,
      super(CartInitial());

  void addToCart(FoodModel food, int quantity) async {
    emit(CartLoading());

    final res = await _cartRemoteRepository.addProductToCart(food, quantity);

    res.fold((l) => emit(CartFailure(l.message)), (_) {
      emit(CartProductAdded());
      fetchCartProducts();
    });
  }

  void fetchCartProducts() async {
    emit(CartLoading());

    _cartSubscription = _cartRemoteRepository.fetchCartProducts().listen((res) {
      res.fold(
        (l) => emit(CartFailure(l.message)),
        (r) => emit(CartProductFetched(r)),
      );
    });
  }

  void deleteCartProduct(String productId) async {
    final res = await _cartRemoteRepository.deleteCartProduct(productId);

    res.fold((l) => emit(CartFailure(l.message)), (_) {});
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
