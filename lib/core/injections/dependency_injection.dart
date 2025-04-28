import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../feature/auth/data/repository/auth_repository_impl.dart';
import '../../feature/auth/domain/repositories/auth_repository.dart';
import '../../feature/auth/domain/usecase/login_use_case.dart';
import '../../feature/auth/presentation/cubit/login_cubit.dart';
import '../../feature/dashborad/data/repositories/product_repository_impl.dart';
import '../../feature/dashborad/domain/repositories/product_repository.dart';
import '../../feature/dashborad/domain/usecases/get_products_usecase.dart';
import '../../feature/dashborad/presentation/bloc/product_bloc.dart';
import '../network/api_client.dart';
import '../services/storage_service.dart';

final sl = GetIt.instance; // sl stands for Service Locator

void init() {
  // Register Services
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => StorageService());

  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(apiClient: sl()));
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(apiClient: sl(),storageService: sl()));

  // Register UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));

  // Register Cubits
  sl.registerFactory(() => LoginCubit(
        loginUseCase: sl(),
        storageService: sl(),
      ));
  // Register ProductBloc
  sl.registerFactory(() => ProductBloc(getProductsUseCase: sl()));

  // Register SharedPreferences instance for session management
  sl.registerLazySingleton(() async => await SharedPreferences.getInstance());
}
