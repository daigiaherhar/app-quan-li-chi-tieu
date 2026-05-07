import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/router/app_route_paths.dart';
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';
import 'package:quan_ly_chi_tieu/core/utils/app_locale_format.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/features/dashboard/presentation/providers/dashboard_providers.dart';
part '../widgets/header/header.dart';
part '../widgets/body/body.dart';
part '../widgets/body/quick_actions.dart';
part '../widgets/body/monthly_chart.dart';
part '../widgets/body/recent_transactions.dart';
part '../widgets/body/surface_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<TransactionEntity>> transactionsAsync = ref.watch(
      dashboardTransactionsProvider,
    );
    final AsyncValue<double> walletTotalAsync = ref.watch(
      dashboardWalletTotalProvider,
    );
    final double walletTotal = walletTotalAsync.when(
      data: (double value) => value,
      loading: () => 0,
      error: (_, __) => 0,
    );
    return ColoredBox(
      color: context.colors.dashboardBackground,
      child: SafeArea(
        bottom: false,
        top: false,
        child: transactionsAsync.when(
          data: (List<TransactionEntity> items) =>
              _DashboardBody(items: items, walletTotal: walletTotal),
          error: (_, __) =>
              _DashboardBody(items: const <TransactionEntity>[], walletTotal: walletTotal),
          loading: () =>
              _DashboardBody(items: const <TransactionEntity>[], walletTotal: walletTotal),
        ),
      ),
    );
  }
}
