import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_theme.dart';
import 'package:money_management_mobile/core/utils/logger.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/injection_container.dart';

late TimezoneInfo localTimezone;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init();
  localTimezone = await FlutterTimezone.getLocalTimezone();

  await initializeDateFormatting('id_ID');
  await initInjectionContainer();

  await sl<SessionCubit>().restoreSession();
  await sl<CategoryCubit>().fetchCategories();
  await sl<DashboardMetricCubit>().fetchDashboardMetrics();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: sl<SessionCubit>()),
        BlocProvider<CategoryCubit>.value(value: sl<CategoryCubit>()),
        BlocProvider<DashboardMetricCubit>.value(
          value: sl<DashboardMetricCubit>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Moco',
        routerConfig: AppRouter.router,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
