import 'package:go_router/go_router.dart';
import 'package:quan_ly_chi_tieu/core/router/app_route_paths.dart';
import 'package:quan_ly_chi_tieu/features/root/presentation/pages/root_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePaths.home,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutePaths.home,
      builder: (
        context,
        state,
      ) {
        return const RootPage();
      },
    ),
  ],
);
