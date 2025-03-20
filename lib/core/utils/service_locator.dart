import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:klontong_flutter_app/core/network/api_service.dart';
import 'package:klontong_flutter_app/core/network/auth_service.dart';
import 'package:klontong_flutter_app/core/storage/database.service.dart';
import 'package:klontong_flutter_app/core/storage/secure_storage.dart';
import 'package:klontong_flutter_app/logic/auth/auth_cubit.dart';
import 'package:klontong_flutter_app/logic/product/product_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Register Dio as a lazy singleton (one instance shared throughout the app)
  getIt.registerLazySingleton<Dio>(() => Dio());

  // Register DatabaseService as a lazy singleton (persistent DB connection)
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());

  // Register ApiService as a lazy singleton, injecting Dio & DatabaseService
  getIt.registerLazySingleton<ApiService>(
      () => ApiService(getIt<Dio>(), getIt<DatabaseService>()));

  // Register ProductCubit as a factory (creates a new instance each time)
  getIt.registerFactory(() => ProductCubit(getIt<ApiService>()));

  // Register SecureStorage as a lazy singleton (persistent secure storage)
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());

  // Register AuthService as a lazy singleton, injecting Dio & SecureStorage
  getIt.registerLazySingleton<AuthService>(
      () => AuthService(getIt<Dio>(), getIt<SecureStorage>()));

  // Register AuthCubit as a factory (creates a new instance each time)
  getIt.registerFactory(() => AuthCubit(getIt<AuthService>()));
}
