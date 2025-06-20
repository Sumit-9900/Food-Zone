import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_admin/features/food/models/food_model.dart';
import 'package:food_admin/features/food/repository/food_remote_repository.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRemoteRepository _foodRemoteRepository;
  final List<String> categories = ['Ice-cream', 'Burger', 'Salad', 'Pizza'];
  late String selectedCategory;
  FoodBloc({required FoodRemoteRepository foodRemoteRepository})
    : _foodRemoteRepository = foodRemoteRepository,
      super(FoodInitial()) {
    selectedCategory = categories[0];
    on<FoodFetched>(_onFoodFetched);
    on<FoodAdded>(_onFoodAdded);
    on<FoodDropdownChanged>(_onDropdownChanged);
    on<FoodDeleted>(_onFoodDeleted);
  }

  void _onFoodFetched(FoodFetched event, Emitter<FoodState> emit) async {
    emit(FoodLoading());

    final res = await _foodRemoteRepository.getAllFoods();

    res.fold((l) => emit(FoodFailure(l.message)), (r) => emit(FoodSuccess(r)));
  }

  void _onFoodAdded(FoodAdded event, Emitter<FoodState> emit) async {
    emit(FoodLoading());

    final res = await _foodRemoteRepository.sendFoodDataToFirestore(
      selectedImage: event.selectedImage,
      productCategory: selectedCategory,
      productDetail: event.productDetail,
      productName: event.productName,
      productPrice: event.productPrice,
    );

    res.fold((l) => emit(FoodFailure(l.message)), (r) {
      emit(FoodAddedSuccess());
      add(FoodFetched());
    });
  }

  void _onDropdownChanged(FoodDropdownChanged event, Emitter<FoodState> emit) {
    selectedCategory = event.dropdownValue;
    emit(FoodCategoryChanged(selectedCategory));
  }

  void _onFoodDeleted(FoodDeleted event, Emitter<FoodState> emit) async {
    final res = await _foodRemoteRepository.deleteFood(event.productId);

    res.fold((l) => emit(FoodFailure(l.message)), (r) {
      add(FoodFetched());
      emit(FoodDeletedSuccess());
    });
  }
}
