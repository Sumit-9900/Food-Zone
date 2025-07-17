import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/core/failure/failure.dart';
import 'package:food_client/features/favorite/repository/favorite_remote_repository.dart';
import 'package:food_client/features/food/models/food_model.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRemoteRepository _favoriteRemoteRepository;
  StreamSubscription<Either<AppFailure, List<String>>>? _favSubscription;
  FavoriteCubit({required FavoriteRemoteRepository favoriteRemoteRepository})
    : _favoriteRemoteRepository = favoriteRemoteRepository,
      super(FavoriteInitial());

  void getFavoriteProducts() {
    emit(FavoriteLoading());

    _favSubscription = _favoriteRemoteRepository.fetchFavoriteFoods().listen((
      res,
    ) {
      res.fold(
        (l) => emit(FavoriteFailure(l.message)),
        (r) => emit(FavoriteSuccess(r)),
      );
    });
  }

  void toggleFavorite(FoodModel food, Set<String> currentFavIds) async {
    if (currentFavIds.contains(food.productId)) {
      final res = await _favoriteRemoteRepository.removeFavorite(
        food.productId,
      );

      res.fold((l) => emit(FavoriteFailure(l.message)), (_) {});
    } else {
      final res = await _favoriteRemoteRepository.addFavorite(food);

      res.fold((l) => emit(FavoriteFailure(l.message)), (_) {});
    }
  }

  @override
  Future<void> close() {
    _favSubscription?.cancel();
    return super.close();
  }
}
