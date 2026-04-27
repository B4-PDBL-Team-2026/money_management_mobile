// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:event_bus/event_bus.dart' as _i1017;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'core/network/http.dart' as _i1026;
import 'core/utils/event_bus.dart' as _i503;
import 'core/utils/local_storage.dart' as _i600;
import 'features/auth/data/data_sources/local/auth_local_data_source.dart'
    as _i465;
import 'features/auth/data/data_sources/remote/auth_remote_data_source.dart'
    as _i711;
import 'features/auth/data/repositories/auth_repository_impl.dart' as _i111;
import 'features/auth/domain/repositories/auth_repository.dart' as _i1015;
import 'features/auth/domain/usecases/login_usecase.dart' as _i206;
import 'features/auth/domain/usecases/register_usecase.dart' as _i693;
import 'features/auth/presentation/cubit/login_cubit.dart' as _i250;
import 'features/auth/presentation/cubit/register_cubit.dart' as _i622;
import 'features/auth/presentation/cubit/reset_password_cubit.dart' as _i801;
import 'features/auth/presentation/cubit/session_cubit.dart' as _i410;
import 'features/auth/presentation/cubit/verify_email_cubit.dart' as _i217;
import 'features/category/data/data_sources/local/category_local_data_sources.dart'
    as _i844;
import 'features/category/data/data_sources/remote/category_remote_data_sources.dart'
    as _i300;
import 'features/category/data/repositories/category_repository_impl.dart'
    as _i44;
import 'features/category/domain/repositories/category_repository.dart' as _i5;
import 'features/category/presentation/cubit/category_cubit.dart' as _i478;
import 'features/dashboard/data/data_sources/remote/dashboard_remote_data_source.dart'
    as _i553;
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i448;
import 'features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i557;
import 'features/dashboard/domain/usecases/calculate_dashboard_metrics_usecase.dart'
    as _i83;
import 'features/dashboard/presentation/cubits/dashboard_metric_cubit.dart'
    as _i1023;
import 'features/dashboard/presentation/cubits/delete_account_cubit.dart'
    as _i111;
import 'features/dashboard/presentation/cubits/unpaid_fixed_cost_occurrences_cubit.dart'
    as _i928;
import 'features/notification/data/data_source/local/notification_local_data_source.dart'
    as _i312;
import 'features/notification/data/services/notification_service.dart' as _i856;
import 'features/notification/presentation/cubit/notification_cubit.dart'
    as _i421;
import 'features/profile/data/data_sources/remote/fixed_cost_template_remote_data_source.dart'
    as _i270;
import 'features/profile/data/data_sources/remote/profile_remote_data_source.dart'
    as _i959;
import 'features/profile/data/repositories/fixed_cost_template_repository_impl.dart'
    as _i1050;
import 'features/profile/data/repositories/profile_repository_impl.dart'
    as _i277;
import 'features/profile/domain/repositories/fixed_cost_template_repository.dart'
    as _i121;
import 'features/profile/domain/repositories/profile_repository.dart' as _i626;
import 'features/profile/domain/usecases/calculate_financial_profile_usecase.dart'
    as _i103;
import 'features/profile/presentation/cubit/financial_profile_draft_cubit.dart'
    as _i715;
import 'features/profile/presentation/cubit/fixed_cost_template_cubit.dart'
    as _i324;
import 'features/profile/presentation/cubit/submit_financial_profile_cubit.dart'
    as _i262;
import 'features/transaction/data/data_sources/remote/transaction_remote_data_source.dart'
    as _i1023;
import 'features/transaction/data/repositories/transaction_repository_impl.dart'
    as _i16;
import 'features/transaction/domain/repositories/transaction_repository.dart'
    as _i463;
import 'features/transaction/presentation/cubit/add_transaction_cubit.dart'
    as _i1024;
import 'features/transaction/presentation/cubit/transaction_detail_cubit.dart'
    as _i555;
import 'features/transaction/presentation/cubit/transaction_history_cubit.dart'
    as _i900;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final localStorage = _$LocalStorage();
    final eventBusModule = _$EventBusModule();
    final http = _$Http();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => localStorage.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i1017.EventBus>(() => eventBusModule.eventBus);
    gh.lazySingleton<_i103.CalculateFinancialProfileUseCase>(
      () => _i103.CalculateFinancialProfileUseCase(),
    );
    gh.lazySingleton<_i465.AuthLocalDataSource>(
      () => _i465.AuthLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i844.CategoryLocalDataSource>(
      () => _i844.CategoryLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i312.NotificationLocalDataSource>(
      () => _i312.NotificationLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i715.FinancialProfileDraftCubit>(
      () => _i715.FinancialProfileDraftCubit(
        gh<_i103.CalculateFinancialProfileUseCase>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => http.dio(gh<_i465.AuthLocalDataSource>()),
    );
    gh.lazySingleton<_i856.NotificationService>(
      () => _i856.NotificationService(gh<_i312.NotificationLocalDataSource>()),
    );
    gh.lazySingleton<_i421.NotificationCubit>(
      () => _i421.NotificationCubit(gh<_i856.NotificationService>()),
    );
    gh.lazySingleton<_i300.CategoryRemoteDataSource>(
      () => _i300.CategoryRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i553.DashboardRemoteDataSource>(
      () => _i553.DashboardRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i270.FixedCostTemplateRemoteDataSource>(
      () => _i270.FixedCostTemplateRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i959.ProfileRemoteDataSource>(
      () => _i959.ProfileRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1023.TransactionRemoteDataSource>(
      () => _i1023.TransactionRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.factory<_i711.AuthRemoteDataSource>(
      () => _i711.AuthRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.factory<_i1015.AuthRepository>(
      () => _i111.AuthRepositoryImpl(
        gh<_i711.AuthRemoteDataSource>(),
        gh<_i465.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i801.ResetPasswordCubit>(
      () => _i801.ResetPasswordCubit(gh<_i1015.AuthRepository>()),
    );
    gh.factory<_i217.VerifyEmailCubit>(
      () => _i217.VerifyEmailCubit(gh<_i1015.AuthRepository>()),
    );
    gh.lazySingleton<_i410.SessionCubit>(
      () => _i410.SessionCubit(gh<_i1015.AuthRepository>()),
    );
    gh.lazySingleton<_i557.DashboardRepository>(
      () =>
          _i448.DashboardRepositoryImpl(gh<_i553.DashboardRemoteDataSource>()),
    );
    gh.lazySingleton<_i5.CategoryRepository>(
      () => _i44.CategoryRepositoryImpl(
        gh<_i300.CategoryRemoteDataSource>(),
        gh<_i844.CategoryLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i121.FixedCostTemplateRepository>(
      () => _i1050.FixedCostTemplateRepositoryImpl(
        gh<_i270.FixedCostTemplateRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i928.UnpaidFixedCostTemplateCubit>(
      () => _i928.UnpaidFixedCostTemplateCubit(
        gh<_i1017.EventBus>(),
        gh<_i557.DashboardRepository>(),
      ),
    );
    gh.factory<_i111.DeleteAccountCubit>(
      () => _i111.DeleteAccountCubit(
        gh<_i1015.AuthRepository>(),
        gh<_i410.SessionCubit>(),
      ),
    );
    gh.factory<_i206.LoginUseCase>(
      () => _i206.LoginUseCase(gh<_i1015.AuthRepository>()),
    );
    gh.factory<_i693.RegisterUseCase>(
      () => _i693.RegisterUseCase(gh<_i1015.AuthRepository>()),
    );
    gh.lazySingleton<_i478.CategoryCubit>(
      () => _i478.CategoryCubit(
        gh<_i5.CategoryRepository>(),
        gh<_i1017.EventBus>(),
      ),
    );
    gh.lazySingleton<_i463.TransactionRepository>(
      () => _i16.TransactionRepositoryImpl(
        gh<_i1023.TransactionRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i324.FixedCostTemplateCubit>(
      () => _i324.FixedCostTemplateCubit(
        gh<_i121.FixedCostTemplateRepository>(),
        gh<_i1017.EventBus>(),
      ),
    );
    gh.factory<_i622.RegisterCubit>(
      () => _i622.RegisterCubit(
        gh<_i693.RegisterUseCase>(),
        gh<_i410.SessionCubit>(),
        gh<_i1017.EventBus>(),
      ),
    );
    gh.lazySingleton<_i626.ProfileRepository>(
      () => _i277.ProfileRepositoryImpl(gh<_i959.ProfileRemoteDataSource>()),
    );
    gh.factory<_i250.LoginCubit>(
      () => _i250.LoginCubit(
        gh<_i206.LoginUseCase>(),
        gh<_i410.SessionCubit>(),
        gh<_i1017.EventBus>(),
      ),
    );
    gh.factory<_i83.CalculateDashboardMetricsUsecase>(
      () => _i83.CalculateDashboardMetricsUsecase(
        gh<_i557.DashboardRepository>(),
      ),
    );
    gh.factory<_i262.SubmitFinancialProfileCubit>(
      () => _i262.SubmitFinancialProfileCubit(
        gh<_i626.ProfileRepository>(),
        gh<_i410.SessionCubit>(),
        gh<_i1017.EventBus>(),
      ),
    );
    gh.factory<_i1024.AddTransactionCubit>(
      () => _i1024.AddTransactionCubit(
        gh<_i463.TransactionRepository>(),
        gh<_i1017.EventBus>(),
      ),
    );
    gh.factory<_i555.TransactionDetailCubit>(
      () => _i555.TransactionDetailCubit(
        gh<_i463.TransactionRepository>(),
        gh<_i1017.EventBus>(),
      ),
    );
    gh.lazySingleton<_i900.TransactionHistoryCubit>(
      () => _i900.TransactionHistoryCubit(
        gh<_i463.TransactionRepository>(),
        gh<_i1017.EventBus>(),
      ),
    );
    gh.lazySingleton<_i1023.DashboardMetricCubit>(
      () => _i1023.DashboardMetricCubit(
        gh<_i83.CalculateDashboardMetricsUsecase>(),
        gh<_i557.DashboardRepository>(),
        gh<_i1017.EventBus>(),
      ),
    );
    return this;
  }
}

class _$LocalStorage extends _i600.LocalStorage {}

class _$EventBusModule extends _i503.EventBusModule {}

class _$Http extends _i1026.Http {}
