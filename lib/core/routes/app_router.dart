import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/forgot_password/forgot_password_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/personalization/step1_personalization_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/personalization/step2_personalization_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/welcome_page.dart';
import 'package:money_management_mobile/features/dashboard/presentation/pages/home_page.dart';
import 'package:money_management_mobile/injection_container.dart';

class AppRouter {
  static const String dashboard = '/';
  static const String welcome = '/welcome';

  static const String login = '/welcome/login';
  static const String forgotPassword = '/welcome/login/forgot-password';

  static const String registration = '/welcome/registration';
  static const String step1Personalization = '/personalization/step-1';
  static const String step2Personalization = '/personalization/step-1/step-2';

  static final router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),

      // auth routes
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
        ],
      ),
      GoRoute(
        path: '/personalization/step-1',
        builder: (context, state) => const Step1PersonalizationPage(),
        routes: [
          GoRoute(
            path: 'step-2',
            builder: (context, state) => const Step2PersonalizationPage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // Kamu bisa cek AuthCubit di sini nanti!
      return null;
    },
  );
}
