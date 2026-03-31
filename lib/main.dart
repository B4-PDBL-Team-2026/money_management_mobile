import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_theme.dart';
import 'package:money_management_mobile/core/utils/logger.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/fixed_cost_occurrences_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_history_cubit.dart';
import 'package:money_management_mobile/injection_container.dart';
import 'package:sentry/sentry.dart';

late TimezoneInfo localTimezone;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hasSentryDsn = AppEnv.sentryDsn.trim().isNotEmpty;
  if (!hasSentryDsn) {
    await _bootstrapAndRunApp(enableSentry: false);
    return;
  }

  await Sentry.init(
    (options) {
      options.dsn = AppEnv.sentryDsn;
      options.environment = AppEnv.environment;
      options.release = AppEnv.release;
      options.tracesSampleRate = double.parse(AppEnv.sentryTracesSampleRate);
    },
    appRunner: () async {
      await _bootstrapAndRunApp(enableSentry: true);
    },
  );
}

Future<void> _bootstrapAndRunApp({required bool enableSentry}) async {
  AppLogger.init(enableSentry: enableSentry);

  await initInjectionContainer();
  localTimezone = await FlutterTimezone.getLocalTimezone();

  await Future.wait([
    initializeDateFormatting('id_ID'),
    sl<SessionCubit>().restoreSession(),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: sl<SessionCubit>()),
        BlocProvider<CategoryCubit>.value(
          value: sl<CategoryCubit>()..fetchCategories(),
        ),
        BlocProvider<TransactionHistoryCubit>.value(
          value: sl<TransactionHistoryCubit>()..getFreshTransactionHistory(),
        ),
        BlocProvider<FixedCostOccurrencesCubit>.value(
          value: sl<FixedCostOccurrencesCubit>(),
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
