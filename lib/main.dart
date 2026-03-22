import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_theme.dart';
import 'package:money_management_mobile/core/utils/logger.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/injection_container.dart';

late TimezoneInfo localTimezone;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  AppLogger.init();
  localTimezone = await FlutterTimezone.getLocalTimezone();
  await initInjectionContainer();
  await sl<SessionCubit>().restoreSession();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<SessionCubit>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Moco',
        routerConfig: AppRouter.router,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
