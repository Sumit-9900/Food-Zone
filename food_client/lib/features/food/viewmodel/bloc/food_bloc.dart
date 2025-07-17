import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_client/features/food/models/food_model.dart';
import 'package:food_client/features/food/repository/food_remote_repository.dart';
import 'package:food_client/features/profile/models/user_model.dart';
import 'package:food_client/features/profile/repository/profile_remote_repository.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRemoteRepository _foodRemoteRepository;
  final ProfileRemoteRepository _profileRemoteRepository;
  FoodBloc({
    required FoodRemoteRepository foodRemoteRepository,
    required ProfileRemoteRepository profileRemoteRepository,
  }) : _foodRemoteRepository = foodRemoteRepository,
       _profileRemoteRepository = profileRemoteRepository,
       super(FoodInitial()) {
    on<FoodCardChanged>(_onChangeFoodIndex);
    on<FoodFetched>(_onFoodFetched);
  }

  void _onChangeFoodIndex(FoodCardChanged event, Emitter<FoodState> emit) {
    final currentState = state;

    if (currentState is FoodSuccess) {
      emit(currentState.copyWith(selectedIndex: event.index));
    }
  }

  void _onFoodFetched(FoodFetched event, Emitter<FoodState> emit) async {
    emit(FoodLoading());

    final Map<String, List<FoodModel>> categorized = {};

    final res = await _foodRemoteRepository.fetchFoods();

    final userResult = await _profileRemoteRepository.fetchUserDetails();

    if (userResult.isLeft()) {
      emit(FoodFailure(userResult.fold((l) => l.message, (r) => '')));
    }

    final userMap = userResult.getOrElse(() => {});
    if (userMap == null) {
      emit(FoodFailure('No user found!'));
      return;
    }

    final user = UserModel.fromMap(userMap);

    res.fold((l) => emit(FoodFailure(l.message)), (foods) {
      for (final food in foods) {
        final key = food.productCategory;
        categorized.putIfAbsent(key, () => []).add(food);
      }
      emit(
        FoodSuccess(
          user: user,
          selectedIndex: 0,
          categorizedFoods: categorized,
          allFoods: foods,
        ),
      );
    });
  }
}
