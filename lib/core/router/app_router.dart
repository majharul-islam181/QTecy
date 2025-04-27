
import 'package:go_router/go_router.dart';
import '../../../feature/auth/presentation/pages/login_page.dart';
import '../../../feature/auth/presentation/pages/splash_screen.dart';
import '../../feature/dashborad/presentation/pages/home_pages.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) =>  LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
