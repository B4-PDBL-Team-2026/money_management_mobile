import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_state.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/forgot_password/forgot_password_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/personalization/step1_personalization_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/personalization/step2_personalization_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/personalization/step3_personalization_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/welcome_page.dart';
import 'package:money_management_mobile/features/dashboard/presentation/layouts/shell_container.dart';
import 'package:money_management_mobile/features/dashboard/presentation/pages/history_dummy_page.dart';
import 'package:money_management_mobile/features/dashboard/presentation/pages/home_page.dart';
import 'package:money_management_mobile/features/dashboard/presentation/pages/other_page.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/add_transaction_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/pages/add_transaction_page.dart';
import 'package:money_management_mobile/injection_container.dart';

class AppRouter {
  static const String welcome = '/welcome';

  static const String login = '/welcome/login';
  static const String forgotPassword = '/welcome/login/forgot-password';

  static const String registration = '/welcome/registration';
  static const String step1Personalization = '/welcome/personalization/step-1';
  static const String step2Personalization = '/welcome/personalization/step-2';
  static const String step3Personalization = '/welcome/personalization/step-3';

  static const String dashboard = '/';
  static const String history = '/history';
  static const String other = '/other';

  static const String addTransaction = '/transaction/add';

  static final SessionCubit _sessionCubit = sl<SessionCubit>();

  static final router = GoRouter(
    initialLocation: '/welcome',
    refreshListenable: GoRouterRefreshStream(_sessionCubit.stream),
    routes: [
      // auth module
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => BlocProvider(
              create: (_) => sl.get<AuthCubit>(),
              child: const LoginPage(),
            ),
            routes: [
              GoRoute(
                path: 'forgot-password',
                builder: (context, state) => const ForgotPasswordPage(),
              ),
            ],
          ),
          GoRoute(
            path: 'registration',
            builder: (context, state) => BlocProvider(
              create: (_) => sl.get<AuthCubit>(),
              child: const RegisterPage(),
            ),
          ),
          GoRoute(
            path: 'personalization/step-1',
            builder: (context, state) => const Step1PersonalizationPage(),
          ),
          GoRoute(
            path: 'personalization/step-2',
            builder: (context, state) => const Step2PersonalizationPage(),
          ),
          GoRoute(
            path: 'personalization/step-3',
            builder: (context, state) => const Step3PersonalizationPage(),
          ),
        ],
      ),

      // dashboard module
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellContainer(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: history,
                builder: (context, state) => const HistoryDummyPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: dashboard,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: other,
                builder: (context, state) => const OtherPage(),
              ),
            ],
          ),
        ],
      ),

      // transaction module
      GoRoute(
        path: '/transaction/add',
        builder: (context, state) => BlocProvider<AddTransactionCubit>(
          create: (_) => sl<AddTransactionCubit>(),
          child: const AddTransactionPage(),
        ),
      ),
    ],

    redirect: (context, state) {
      final isAuthenticated = _sessionCubit.state is SessionAuthenticated;
      final location = state.matchedLocation;
      final isAuthRoute =
          location == welcome || location.startsWith('$welcome/');
      final isProtectedRoute =
          location == dashboard || location == history || location == other;

      if (!isAuthenticated && isProtectedRoute) {
        return welcome;
      }

      if (isAuthenticated && isAuthRoute) {
        return dashboard;
      }

      return null;
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
