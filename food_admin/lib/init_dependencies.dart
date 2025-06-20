import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_admin/core/viewmodel/cubit/image_picker_cubit.dart';
import 'package:food_admin/features/auth/repository/auth_local_repository.dart';
import 'package:food_admin/features/auth/repository/auth_remote_repository.dart';
import 'package:food_admin/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:food_admin/features/food/repository/food_remote_repository.dart';
import 'package:food_admin/features/food/viewmodel/bloc/food_bloc.dart';
import 'package:food_admin/features/order/repository/order_remote_repository.dart';
import 'package:food_admin/features/order/viewmodel/bloc/order_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final firestore = FirebaseFirestore.instance;

  final storage = FirebaseStorage.instance;

  final prefs = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => firestore);

  getIt.registerLazySingleton(() => storage);

  getIt.registerLazySingleton(() => prefs);

  // Repository
  getIt.registerFactory<AuthRemoteRepository>(
    () => AuthRemoteRepositoryImpl(firestore: getIt()),
  );

  getIt.registerFactory<AuthLocalRepository>(
    () => AuthLocalRepositoryImpl(prefs),
  );

  getIt.registerFactory<FoodRemoteRepository>(
    () => FoodRemoteRepositoryImpl(firestore: getIt(), storage: getIt()),
  );

  getIt.registerFactory<OrderRemoteRepository>(
    () => OrderRemoteRepositoryImpl(firestore: getIt()),
  );

  // Bloc
  getIt.registerLazySingleton(
    () => AuthBloc(authRemoteRepository: getIt(), authLocalRepository: getIt()),
  );

  getIt.registerLazySingleton(() => FoodBloc(foodRemoteRepository: getIt()));

  getIt.registerLazySingleton(() => OrderBloc(orderRemoteRepository: getIt()));

  // Cubit
  getIt.registerLazySingleton(() => ImagePickerCubit());
}
