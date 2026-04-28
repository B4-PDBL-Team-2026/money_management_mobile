import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/login_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/register_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_state.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/verify_email_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/forgot_password/forgot_password_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/forgot_password/send_success_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/welcome_page.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/delete_account_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/unpaid_fixed_cost_occurrences_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/layouts/shell_container.dart';
import 'package:money_management_mobile/features/dashboard/presentation/pages/delete_account_page.dart';
import 'package:money_management_mobile/features/dashboard/presentation/pages/home_page.dart';
import 'package:money_management_mobile/features/dashboard/presentation/pages/other_page.dart';
import 'package:money_management_mobile/features/notification/presentation/pages/notification_center_page.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/submit_financial_profile_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/pages/fixed_cost_occurence_page.dart';
import 'package:money_management_mobile/features/profile/presentation/pages/fixed_cost_template_management_page.dart';
import 'package:money_management_mobile/features/profile/presentation/pages/onboarding/step1_personalization_page.dart';
import 'package:money_management_mobile/features/profile/presentation/pages/onboarding/step2_personalization_page.dart';
import 'package:money_management_mobile/features/profile/presentation/pages/onboarding/step3_personalization_page.dart';
import 'package:money_management_mobile/features/profile/presentation/pages/onboarding/step4_personalization_page.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/add_transaction_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/transaction_detail_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/pages/add_transaction_page.dart';
import 'package:money_management_mobile/features/transaction/presentation/pages/detail_transaction.dart';
import 'package:money_management_mobile/features/transaction/presentation/pages/transaction_history_page.dart';
import 'package:money_management_mobile/injection_container.dart';
import 'package:money_management_mobile/outer_shell.dart';

final _appRouterLogging = Logger('AppRouter');

class AppRouter {
  static const String welcome = '/welcome';

  static const String login = '/welcome/login';
  static const String forgotPassword = '/welcome/login/forgot-password';
  static const String forgotPasswordSuccess =
      '/welcome/login/forgot-password/success';

  static const String registration = '/welcome/registration';

  static const String step1Personalization = '/personalization/step-1';
  static const String step2Personalization = '/personalization/step-2';
  static const String step3Personalization = '/personalization/step-3';
  static const String step4Personalization = '/personalization/step-4';

  static const String dashboard = '/';
  static const String notification = '/notification';
  static const String history = '/history';
  static const String other = '/other';
  static const String fixedCostsOccurence = '/fixed-costs';
  static const String fixedCostsManagement = '/fixed-costs/manage';
  static const String deleteAccount = '/other/delete-account';

  static const String addTransaction = '/transaction/add';
  static const String transactionDetailBase = '/transaction';
  static const String transactionDetail = '/transaction/:id';

  static final SessionCubit _sessionCubit = getIt<SessionCubit>();

  static final router = GoRouter(
    initialLocation: '/welcome',
    refreshListenable: GoRouterRefreshStream(_sessionCubit.stream),
    routes: [
      ShellRoute(
        builder: (context, state, child) => OuterShell(child: child),
        routes: [
          // auth module
          GoRoute(
            path: '/welcome',
            builder: (context, state) => const WelcomePage(),
            routes: [
              GoRoute(
                path: 'login',
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<LoginCubit>(),
                  child: const LoginPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'forgot-password',
                    builder: (context, state) => BlocProvider(
                      create: (_) => getIt<ResetPasswordCubit>(),
                      child: const ForgotPasswordPage(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'success',
                        builder: (context, state) => const SendSuccessPage(),
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: 'registration',
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<RegisterCubit>(),
                  child: const RegisterPage(),
                ),
              ),
            ],
          ),

          GoRoute(
            path: '/personalization/step-1',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: getIt<FinancialProfileDraftCubit>()),
                BlocProvider.value(value: getIt<SubmitFinancialProfileCubit>()),
              ],
              child: const Step1PersonalizationPage(),
            ),
          ),
          GoRoute(
            path: '/personalization/step-2',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: getIt<FinancialProfileDraftCubit>()),
                BlocProvider.value(value: getIt<SubmitFinancialProfileCubit>()),
              ],
              child: const Step2PersonalizationPage(),
            ),
          ),
          GoRoute(
            path: '/personalization/step-3',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: getIt<FinancialProfileDraftCubit>()),
                BlocProvider.value(value: getIt<SubmitFinancialProfileCubit>()),
              ],
              child: const Step3PersonalizationPage(),
            ),
          ),
          GoRoute(
            path: '/personalization/step-4',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: getIt<FinancialProfileDraftCubit>()),
                BlocProvider.value(value: getIt<SubmitFinancialProfileCubit>()),
              ],
              child: const Step4PersonalizationPage(),
            ),
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
                    path: notification,
                    builder: (context, state) => const NotificationCenterPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: history,
                    builder: (context, state) => const TransactionHistoryPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: dashboard,
                    builder: (context, state) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: getIt<DashboardMetricCubit>()
                            ..fetchDashboardMetrics(),
                        ),
                        BlocProvider.value(
                          value: getIt<UnpaidFixedCostTemplateCubit>()
                            ..fetchUnpaidFixedCosts(),
                        ),
                      ],
                      child: const HomePage(),
                    ),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: fixedCostsOccurence,
                    builder: (context, state) => const FixedCostOccurencePage(),
                    routes: [
                      GoRoute(
                        path: 'manage',
                        builder: (context, state) =>
                            const FixedCostTemplateManagementPage(),
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: other,
                    builder: (context, state) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (_) => getIt<ResetPasswordCubit>(),
                        ),
                        BlocProvider(create: (_) => getIt<VerifyEmailCubit>()),
                      ],
                      child: const OtherPage(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'delete-account',
                        builder: (context, state) => BlocProvider(
                          create: (context) => getIt<DeleteAccountCubit>(),
                          child: const DeleteAccountPage(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // transaction module
          GoRoute(
            path: '/transaction/add',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => getIt<AddTransactionCubit>()),
                BlocProvider.value(value: getIt<DashboardMetricCubit>()),
              ],
              child: const AddTransactionPage(),
            ),
          ),
          GoRoute(
            path: transactionDetail,
            builder: (context, state) {
              final idParam = state.pathParameters['id'];
              final id = int.tryParse(idParam ?? '');

              if (id == null) {
                return const Scaffold(
                  body: Center(child: Text('ID transaksi tidak valid.')),
                );
              }

              return BlocProvider<TransactionDetailCubit>(
                create: (_) => getIt<TransactionDetailCubit>(),
                child: TransactionDetailPage(transactionId: id),
              );
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final sessionState = _sessionCubit.state;
      final isAuthenticated = sessionState is SessionAuthenticated;
      final requiresOnboarding =
          isAuthenticated && sessionState.requiresOnboarding;

      final location = state.matchedLocation;
      _appRouterLogging.info('Attempting to navigate to: $location');

      final isAuthRoute = location.startsWith(welcome);
      final isOnboardingRoute = location.startsWith('/personalization');

      if (!isAuthenticated) {
        _appRouterLogging.info(
          'User is not authenticated. Checking access for: $location',
        );
        return isAuthRoute ? null : welcome;
      }

      if (requiresOnboarding) {
        _appRouterLogging.info(
          'User is authenticated but requires onboarding. Checking access for: $location',
        );
        return isOnboardingRoute ? null : step1Personalization;
      }

      if (isAuthRoute || isOnboardingRoute) {
        _appRouterLogging.info(
          'User is authenticated and completed onboarding. Checking access for: $location',
        );
        return dashboard;
      }
      _appRouterLogging.info(
        'User is authenticated and accessing allowed route: $location',
      );
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
