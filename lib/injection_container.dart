import 'package:get_it/get_it.dart';
import 'package:money_management_mobile/core/network/http.dart';
import 'package:money_management_mobile/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:money_management_mobile/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:money_management_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/register_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initInjectionContainer() async {
  // third party packages
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sl()),
  );
  sl.registerLazySingleton(() => createDioClient(sl<AuthLocalDataSource>()));

  // Features - Auth
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl(), sl()));
  sl.registerLazySingleton<SessionCubit>(() => SessionCubit(sl(), sl()));
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl(), sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<RestoreSessionUseCase>(
    () => RestoreSessionUseCase(sl()),
  );
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );
}
