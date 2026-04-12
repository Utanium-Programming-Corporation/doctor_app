import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_state.dart';
import 'placeholder_pages.dart';
import 'route_names.dart';
import 'scaffold_with_nav_bar.dart';

class AppRouter {
  final AuthStateNotifier _authStateNotifier;

  AppRouter(this._authStateNotifier);

  late final GoRouter router = GoRouter(
    initialLocation: '/home',
    refreshListenable: _authStateNotifier,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginPlaceholderPage(),
      ),
      GoRoute(
        path: '/access-denied',
        name: RouteNames.accessDenied,
        builder: (context, state) => const AccessDeniedPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: RouteNames.home,
                builder: (context, state) => const HomePlaceholderPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: RouteNames.settings,
                builder: (context, state) => const SettingsPlaceholderPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final status = _authStateNotifier.status;
    final isOnLogin = state.matchedLocation == '/login';
    final isOnAccessDenied = state.matchedLocation == '/access-denied';

    // Auth state not yet determined — stay on current route
    if (status == AuthStatus.unknown) {
      return null;
    }

    // Not authenticated — go to login (unless already there)
    if (status == AuthStatus.unauthenticated) {
      return isOnLogin ? null : '/login';
    }

    // Authenticated but on login — go to home
    if (isOnLogin) {
      return '/home';
    }

    // Authenticated on access-denied — allow (they may have navigated here)
    if (isOnAccessDenied) {
      return null;
    }

    // All checks passed — allow navigation
    return null;
  }
}
