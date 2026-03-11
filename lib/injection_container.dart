import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:money_management_mobile/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:money_management_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> initInjectionContainer() async {
  // third party packages
  sl.registerLazySingleton(
    () => Dio(BaseOptions(baseUrl: 'https://api.example.com')),
  );

  // Features - Auth
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl(), sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(sl()));
}
