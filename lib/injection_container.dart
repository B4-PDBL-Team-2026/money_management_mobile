import 'package:get_it/get_it.dart';
import 'package:money_management_mobile/core/network/http.dart';
import 'package:money_management_mobile/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:money_management_mobile/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:money_management_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:money_management_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/complete_onboarding_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:money_management_mobile/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/login_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/register_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/profile/data/data_sources/remote/onboarding_remote_data_source.dart';
import 'package:money_management_mobile/features/profile/data/repositories/onboarding_repository_impl.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/onboarding_repository.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_onboarding_budget_usecase.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/submit_onboarding_usecase.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_cubit.dart';
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
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl(), sl()));
  sl.registerLazySingleton<SessionCubit>(() => SessionCubit(sl(), sl()));
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl(), sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<RestoreSessionUseCase>(
    () => RestoreSessionUseCase(sl()),
  );
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
  sl.registerLazySingleton<CompleteOnboardingUseCase>(
    () => CompleteOnboardingUseCase(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );

  // Features - Profile (Onboarding)
  sl.registerLazySingleton<FinancialProfileDraftCubit>(
    () => FinancialProfileDraftCubit(sl()),
  );
  sl.registerLazySingleton<SubmitFinancialProfileCubit>(
    () => SubmitFinancialProfileCubit(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<CalculateOnboardingBudgetUseCase>(
    () => CalculateOnboardingBudgetUseCase(),
  );
  sl.registerLazySingleton<SubmitOnboardingUseCase>(
    () => SubmitOnboardingUseCase(sl()),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSource(sl()),
  );
}
