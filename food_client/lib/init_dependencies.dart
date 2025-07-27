import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_client/features/auth/repository/auth_remote_repository.dart';
import 'package:food_client/features/auth/viewmodel/bloc/forgot_password_bloc.dart';
import 'package:food_client/features/auth/viewmodel/bloc/login_bloc.dart';
import 'package:food_client/features/auth/viewmodel/bloc/signup_bloc.dart';
import 'package:food_client/features/bottomNav/viewmodel/cubit/bottom_nav_cubit.dart';
import 'package:food_client/features/cart/repository/cart_remote_repository.dart';
import 'package:food_client/features/cart/viewmodel/cubit/address_cubit.dart';
import 'package:food_client/features/cart/viewmodel/cubit/cart_cubit.dart';
import 'package:food_client/features/favorite/repository/favorite_remote_repository.dart';
import 'package:food_client/features/favorite/viewmodel/cubit/favorite_cubit.dart';
import 'package:food_client/features/food/repository/food_remote_repository.dart';
import 'package:food_client/features/food/viewmodel/bloc/food_bloc.dart';
import 'package:food_client/features/food/viewmodel/cubit/food_quantity_cubit.dart';
import 'package:food_client/features/onboarding/viewmodel/cubit/onboarding_cubit.dart';
import 'package:food_client/features/order/repository/order_remote_repository.dart';
import 'package:food_client/features/order/viewmodel/bloc/order_bloc.dart';
import 'package:food_client/features/payment/repository/payment_remote_repository.dart';
import 'package:food_client/features/payment/viewmodel/cubit/payment_cubit.dart';
import 'package:food_client/features/profile/repository/profile_remote_repository.dart';
import 'package:food_client/features/profile/viewmodel/cubit/profile_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  FirebaseOptions options = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'],
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    appId: dotenv.env['FIREBASE_APP_ID']!,
    measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
  );

  await Firebase.initializeApp(options: options);

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final httpClient = http.Client();

  firestore.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    sslEnabled: true,
  );

  // Repository
  getIt.registerFactory<AuthRemoteRepository>(
    () => AuthRemoteRepositoryImpl(
      auth: auth,
      firestore: firestore,
      storage: storage,
    ),
  );

  getIt.registerFactory<ProfileRemoteRepository>(
    () => ProfileRemoteRepositoryImpl(
      storage: storage,
      auth: auth,
      firestore: firestore,
    ),
  );

  getIt.registerFactory<FoodRemoteRepository>(
    () => FoodRemoteRepositoryImpl(firestore: firestore, auth: auth),
  );

  getIt.registerFactory<FavoriteRemoteRepository>(
    () => FavoriteRemoteRepositoryImpl(firestore: firestore, auth: auth),
  );

  getIt.registerFactory<CartRemoteRepository>(
    () => CartRemoteRepositoryImpl(firestore: firestore, auth: auth),
  );

  getIt.registerFactory<PaymentRemoteRepository>(
    () => PaymentRemoteRepositoryImpl(httpClient),
  );

  getIt.registerFactory<OrderRemoteRepository>(
    () => OrderRemoteRepositoryImpl(
      firestore: firestore,
      auth: auth,
      httpClient: httpClient,
    ),
  );

  // Bloc
  getIt.registerLazySingleton(() => SignupBloc(authRemoteRepository: getIt()));

  getIt.registerLazySingleton(() => LoginBloc(authRemoteRepository: getIt()));

  getIt.registerLazySingleton(
    () => ForgotPasswordBloc(authRemoteRepository: getIt()),
  );

  getIt.registerLazySingleton(
    () => FoodBloc(
      foodRemoteRepository: getIt(),
      profileRemoteRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => OrderBloc(orderRemoteRepository: getIt()));

  // Cubit
  getIt.registerLazySingleton(() => OnboardingCubit());

  getIt.registerLazySingleton(() => BottomNavCubit());

  getIt.registerLazySingleton(
    () => ProfileCubit(
      profileRemoteRepository: getIt(),
      authRemoteRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => FavoriteCubit(favoriteRemoteRepository: getIt()),
  );

  getIt.registerFactory(() => FoodQuantityCubit());

  getIt.registerLazySingleton(() => CartCubit(cartRemoteRepository: getIt()));

  getIt.registerLazySingleton(
    () => AddressCubit(cartRemoteRepository: getIt()),
  );

  getIt.registerLazySingleton(
    () => PaymentCubit(paymentRemoteRepository: getIt()),
  );
}
