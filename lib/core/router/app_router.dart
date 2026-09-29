import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_chi_tieu/core/router/app_route_paths.dart';
import 'package:quan_ly_chi_tieu/core/router/tracking_navigator_observer.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/presentation/pages/ocr_transaction_confirm_page.dart';
import 'package:quan_ly_chi_tieu/features/profile/presentation/providers/profile_providers.dart';
import 'package:quan_ly_chi_tieu/features/root/presentation/pages/root_page.dart';
import 'package:quan_ly_chi_tieu/features/splash/presentation/pages/splash_page.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/pages/transaction_page.dart';
import 'package:quan_ly_chi_tieu/features/wallets/presentation/pages/wallets_page.dart';

final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((Ref ref) {
  final ValueNotifier<int> refresh = ValueNotifier<int>(0);
  ref.listen<AsyncValue<bool>>(hasUserInfoProvider, (
    AsyncValue<bool>? previous,
    AsyncValue<bool> next,
  ) {
    refresh.value++;
  });
  final GoRouter router = GoRouter(
    initialLocation: AppRoutePaths.splash,
    refreshListenable: refresh,
    observers: <NavigatorObserver>[TrackingNavigatorObserver()],
    redirect: (BuildContext context, GoRouterState state) {
      final AsyncValue<bool> asyncHas = ref.read(hasUserInfoProvider);
      final String location = state.matchedLocation;
      final bool mustShowSplash = asyncHas.isLoading || asyncHas.hasError;
      if (mustShowSplash && location != AppRoutePaths.splash) {
        return AppRoutePaths.splash;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePaths.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: AppRoutePaths.home,
        builder: (BuildContext context, GoRouterState state) {
          return const RootPage();
        },
      ),
      GoRoute(
        path: AppRoutePaths.transaction,
        builder: (BuildContext context, GoRouterState state) {
          return TransactionPage.fromRoute(state);
        },
      ),
      GoRoute(
        path: AppRoutePaths.ocrTransactionConfirm,
        builder: (BuildContext context, GoRouterState state) {
          return OcrTransactionConfirmPage.fromRoute(state);
        },
      ),
      GoRoute(
        path: AppRoutePaths.wallets,
        builder: (BuildContext context, GoRouterState state) {
          return const WalletsPage();
        },
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
