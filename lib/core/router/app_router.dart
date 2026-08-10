// core/router/app_router.dart
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/cubit/auth_state.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/location/presentation/screens/location_screen.dart';
import 'go_router_refresh_stream.dart';

GoRouter buildAppRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final session = authCubit.state;
      final isChecking = session is AuthChecking;
      final isAuthenticated = session is AuthAuthenticated;
      final goingToAuthPages = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      debugPrint(
        '[ROUTER] redirect called | matchedLocation=${state.matchedLocation} '
        '| authState=$session | isChecking=$isChecking | isAuthenticated=$isAuthenticated '
        '| goingToAuthPages=$goingToAuthPages',
      );

      if (isChecking) {
        debugPrint('[ROUTER] -> staying (still AuthChecking), no redirect');
        return null;
      }
      if (!isAuthenticated && !goingToAuthPages) {
        debugPrint('[ROUTER] -> redirecting to /login (not authenticated)');
        return '/login';
      }
      if (isAuthenticated && goingToAuthPages) {
        debugPrint('[ROUTER] -> redirecting to /home (already authenticated)');
        return '/home';
      }
      debugPrint('[ROUTER] -> no redirect needed');
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final isChecking = authCubit.state is AuthChecking;
          debugPrint(
              '[ROUTER] building /login | authState=${authCubit.state} | showingSplash=$isChecking');
          return isChecking ? const SplashScreen() : const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          debugPrint(
              '[ROUTER] building /register | authState=${authCubit.state}');
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          debugPrint('[ROUTER] building /home | authState=${authCubit.state}');
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/location',
        builder: (context, state) {
          debugPrint(
              '[ROUTER] building /location | authState=${authCubit.state}');
          return const LocationScreen();
        },
      ),
    ],
  );
}
