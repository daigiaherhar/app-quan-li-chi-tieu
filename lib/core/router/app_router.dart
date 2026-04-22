import 'package:go_router/go_router.dart';
import 'package:quan_ly_chi_tieu/core/router/app_route_paths.dart';
import 'package:quan_ly_chi_tieu/features/test_blabla/presentation/pages/test_blabla_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePaths.testBlabla,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutePaths.testBlabla,
      builder: (
        context,
        state,
      ) {
        return const TestBlablaPage();
      },
    ),
  ],
);
