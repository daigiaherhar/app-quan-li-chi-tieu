part of '../../pages/dashboard_page.dart';

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final List<TransactionEntity> items = kMockTransactions;
    final _MonthlySummary summary = _MonthlySummary.fromTransactions(items);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.w(context),
        12.w(context),
        16.w(context),
        18.w(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: kToolbarHeight),
          const _GreetingRow(),
          context.gap.h20,
          _BalanceHeroCard(summary: summary),
        ],
      ),
    ).animate().slideY(
          begin: -1,
          end: 0,
          duration: 800.ms,
          curve: Curves.easeOutBack,
        ).fadeIn(duration: 600.ms);
  }
}

class _GreetingRow extends StatelessWidget {
  const _GreetingRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${_greetingText()}, Bạn ${_greetingEmoji()}',
                style: context.textStyles.h3.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              context.gap.h4,
              Text(
                'Chúc bạn một ngày tài chính vững vàng.',
                style: context.textStyles.bodySmall.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const _NotificationButton(),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: context.colors.cardSurface,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.colors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(
            Icons.notifications_none_rounded,
            color: context.colors.textPrimary,
            size: 22,
          ),
          Positioned(
            top: 11,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: context.colors.expense,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colors.cardSurface,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceHeroCard extends StatelessWidget {
  const _BalanceHeroCard({required this.summary});

  final _MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final List<Color> gradient = context.colors.heroGradient;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 22.w(context),
        vertical: 22.w(context),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Tổng số dư',
                style: context.textStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  letterSpacing: 0.4,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w(context),
                  vertical: 4.w(context),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    context.gap.w4,
                    Text(
                      'Tháng này',
                      style: context.textStyles.label.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.gap.h8,
          Text(
            _formatCurrency(summary.balance),
            style: context.textStyles.h1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 30.w(context),
            ),
          ),
          context.gap.h20,
          Row(
            children: <Widget>[
              Expanded(
                child: _HeroStatTile(
                  label: 'Thu nhập',
                  amount: _formatSignedCurrency(
                    summary.income,
                    isExpense: false,
                  ),
                  icon: Icons.south_west_rounded,
                  iconColor: context.colors.income,
                ),
              ),
              context.gap.w12,
              Expanded(
                child: _HeroStatTile(
                  label: 'Chi tiêu',
                  amount: _formatSignedCurrency(
                    summary.expense,
                    isExpense: true,
                  ),
                  icon: Icons.north_east_rounded,
                  iconColor: context.colors.expense,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStatTile extends StatelessWidget {
  const _HeroStatTile({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String amount;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w(context),
        vertical: 10.w(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 16, color: iconColor),
          ),
          context.gap.w8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: context.textStyles.label.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlySummary {
  const _MonthlySummary({required this.income, required this.expense});

  factory _MonthlySummary.fromTransactions(List<TransactionEntity> items) {
    final DateTime now = DateTime.now();
    double income = 0;
    double expense = 0;
    for (final TransactionEntity tx in items) {
      if (tx.happenedAt.year != now.year || tx.happenedAt.month != now.month) {
        continue;
      }
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else if (tx.type == TransactionType.expense) {
        expense += tx.amount;
      }
    }
    return _MonthlySummary(income: income, expense: expense);
  }

  final double income;
  final double expense;

  double get balance => income - expense;
}
