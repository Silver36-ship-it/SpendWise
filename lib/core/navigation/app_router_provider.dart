import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/registration_page.dart';
import '../../features/auth/presentation/providers/riverpod_auth_provider.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/more/presentation/pages/more_page.dart';
import '../../features/transactions/domain/entities/transaction.dart';
import '../../features/transactions/presentation/pages/add_transaction_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import 'dashboard_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/login',

    redirect: (context, state) {
      final authState = ref.read(authProvider);

      if (authState.isLoading) {
        return null;
      }

      final auth = authState.valueOrNull;
      final isLoggedIn = auth?.user != null;

      final isGoingToLogin =
          state.matchedLocation == '/login';

      final isGoingToRegister =
          state.matchedLocation == '/register';

      if (!isLoggedIn &&
          !isGoingToLogin &&
          !isGoingToRegister) {
        return '/login';
      }

      if (isLoggedIn &&
          (isGoingToLogin || isGoingToRegister)) {
        return '/dashboard';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginPage();
        },
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) {
          return const RegisterPage();
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (
            context,
            state,
            navigationShell,
            ) {
          return DashboardShell(
            navigationShell: navigationShell,
          );
        },

        branches: [

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) {
                  return const DashboardPage();
                },
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) {
                  return const TransactionsPage();
                },
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                builder: (context, state) {
                  return const CategoriesPage();
                },
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (context, state) {
                  return const MorePage();
                },
              ),
            ],
          ),
        ],
      ),


      GoRoute(
        path: '/transaction',
        builder: (context, state) {
          return const AddTransactionPage();
        },
      ),

      GoRoute(
        path: '/transaction/edit',
        builder: (context, state) {
          final transaction =
          state.extra as Transaction?;

          return AddTransactionPage(
            transaction: transaction,
          );
        },
      ),
    ],
  );

  ref.listen(
    authProvider,
        (_, __) {
      router.refresh();
    },
  );

  ref.onDispose(router.dispose);

  return router;
});