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
import 'package:money_management_mobile/features/category/data/data_sources/local/category_local_data_sources.dart';
import 'package:money_management_mobile/features/category/data/data_sources/remote/category_remote_data_sources.dart';
import 'package:money_management_mobile/features/category/data/repositories/category_repository_impl.dart';
import 'package:money_management_mobile/features/category/domain/repositories/category_repository.dart';
import 'package:money_management_mobile/features/category/domain/usecases/clear_categories_usecase.dart';
import 'package:money_management_mobile/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/dashboard/data/data_sources/remote/dashboard_remote_data_source.dart';
import 'package:money_management_mobile/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:money_management_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:money_management_mobile/features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/profile/data/data_sources/remote/profile_remote_data_source.dart';
import 'package:money_management_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/calculate_financial_profile_usecase.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/get_fixed_cost_occurrences_usecase.dart';
import 'package:money_management_mobile/features/profile/domain/usecases/submit_financial_profile_usecase.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/fixed_cost_occurrences_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_cubit.dart';
import 'package:money_management_mobile/features/transaction/data/data_sources/remote/transaction_remote_data_source.dart';
import 'package:money_management_mobile/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:money_management_mobile/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:money_management_mobile/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:money_management_mobile/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/add_transaction_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initInjectionContainer() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  // third party packages
  sl.registerLazySingleton(() => sharedPreferences);

  // Features - Auth
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sl()),
  );
  sl.registerLazySingleton(() => createDioClient(sl<AuthLocalDataSource>()));
  sl.registerLazySingleton<LoginCubit>(
    () => LoginCubit(sl(), sl(), sl(), sl()),
  );
  sl.registerLazySingleton<SessionCubit>(() => SessionCubit(sl(), sl(), sl()));
  sl.registerLazySingleton<RegisterCubit>(
    () => RegisterCubit(sl(), sl(), sl(), sl()),
  );
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

  // Features - Transaction
  sl.registerFactory<AddTransactionCubit>(
    () => AddTransactionCubit(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<AddTransactionUseCase>(
    () => AddTransactionUseCase(sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<CompleteOnboardingUseCase>(
    () => CompleteOnboardingUseCase(sl()),
  );
  sl.registerLazySingleton<TransactionHistoryCubit>(
    () => TransactionHistoryCubit(sl()),
  );
  // sl.registerLazySingleton<TransactionHistoryQueryCubit>(
  //   () => TransactionHistoryQueryCubit(),
  // );
  sl.registerLazySingleton<GetTransactionsUsecase>(
    () => GetTransactionsUsecase(sl()),
  );

  // Features - Profile
  sl.registerLazySingleton<FinancialProfileDraftCubit>(
    () => FinancialProfileDraftCubit(sl()),
  );
  sl.registerLazySingleton<SubmitFinancialProfileCubit>(
    () => SubmitFinancialProfileCubit(sl(), sl()),
  );
  sl.registerLazySingleton<FixedCostOccurrencesCubit>(
    () => FixedCostOccurrencesCubit(sl()),
  );
  sl.registerLazySingleton<CalculateFinancialProfileUseCase>(
    () => CalculateFinancialProfileUseCase(),
  );
  sl.registerLazySingleton<GetFixedCostOccurrencesUseCase>(
    () => GetFixedCostOccurrencesUseCase(sl()),
  );
  sl.registerLazySingleton<SubmitFinancialProfileUseCase>(
    () => SubmitFinancialProfileUseCase(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl()),
  );

  // Features - Category
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSource(sl()),
  );
  sl.registerLazySingleton<GetCategoriesUsecase>(
    () => GetCategoriesUsecase(sl()),
  );
  sl.registerLazySingleton<ClearCategoriesUsecase>(
    () => ClearCategoriesUsecase(sl()),
  );
  sl.registerLazySingleton<CategoryCubit>(() => CategoryCubit(sl(), sl()));

  // Features - Dashboard
  sl.registerLazySingleton<DashboardMetricCubit>(
    () => DashboardMetricCubit(sl()),
  );
  sl.registerLazySingleton<CalculateDashboardMetricsUsecase>(
    () => CalculateDashboardMetricsUsecase(sl()),
  );
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );
}
