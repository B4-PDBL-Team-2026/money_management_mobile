import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/login_success_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/registration_success_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/verification_page.dart';
import 'package:money_management_mobile/features/auth/presentation/pages/welcome_page.dart';
import 'package:money_management_mobile/features/dashboard/presentation/pages/home_page.dart';
import 'package:money_management_mobile/injection_container.dart';

class AppRouter {
  static const String dashboard = '/';
  static const String welcome = '/welcome';

  static const String login = '/login';
  static const String loginSuccess = '/login/success';
  static const String forgotPassword = '/login/forgot-password';

  static const String registration = '/registration';
  static const String registrationSuccess = '/registration/success';
  static const String verification = '/registration/verification';

  static final router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),

      // auth routes
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'forgot-password',
            builder: (context, state) => const ForgotPasswordPage(),
          ),
          GoRoute(
            path: 'success',
            builder: (context, state) => const LoginSuccessPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/registration',
        builder: (context, state) => BlocProvider(
          create: (_) => sl.get<AuthCubit>(),
          child: const RegisterPage(),
        ),
        routes: [
          GoRoute(
            path: 'verification',
            builder: (context, state) => const VerificationPage(),
          ),
          GoRoute(
            path: 'success',
            builder: (context, state) => const RegistrationSuccessPage(),
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
