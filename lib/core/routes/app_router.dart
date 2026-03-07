import 'package:go_router/go_router.dart';

class AppRouter {
  static const String login = '/login';
  static const String dashboard = '/';

  static final router = GoRouter(
    initialLocation: login,
    routes: [
      // route definitions
    ],
    redirect: (context, state) {
      // Kamu bisa cek AuthCubit di sini nanti!
      return null;
    },
  );
}
