part of '../../pages/dashboard_page.dart';

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    final List<TransactionEntity> items = kMockTransactions;
    final double bottomPadding =
        MediaQuery.paddingOf(context).bottom + 96.w(context);

    return ListView(
      padding: EdgeInsets.only(bottom: bottomPadding),
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        const _DashboardHeader(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _QuickActionsRow(),
              context.gap.h24,
              _MonthlyChartCard(items: items),
              context.gap.h24,
              _RecentTransactionsCard(items: items),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(
              begin: 0.2,
              end: 0,
              duration: 600.ms,
              curve: Curves.easeOutQuad,
            ),
      ],
    );
  }
}
