// core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/location/presentation/screens/location_screen.dart';
import 'go_router_refresh_stream.dart';

Page<void> _buildSmoothPage(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final slide =
          Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

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
        pageBuilder: (context, state) {
          final isChecking = authCubit.state is AuthChecking;
          debugPrint(
              '[ROUTER] building /login | authState=${authCubit.state} | showingSplash=$isChecking');
          return _buildSmoothPage(
              isChecking ? const SplashScreen() : const LoginScreen());
        },
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) {
          debugPrint(
              '[ROUTER] building /register | authState=${authCubit.state}');
          return _buildSmoothPage(const RegisterScreen());
        },
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) {
          debugPrint('[ROUTER] building /home | authState=${authCubit.state}');
          return _buildSmoothPage(const HomeScreen());
        },
      ),
      GoRoute(
        path: '/location',
        pageBuilder: (context, state) {
          debugPrint(
              '[ROUTER] building /location | authState=${authCubit.state}');
          return _buildSmoothPage(const LocationScreen());
        },
      ),
    ],
  );
}
