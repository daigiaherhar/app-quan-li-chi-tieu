part of '../../pages/dashboard_page.dart';

class _RecentTransactionsCard extends StatelessWidget {
  const _RecentTransactionsCard({required this.items});

  final List<TransactionEntity> items;

  @override
  Widget build(BuildContext context) {
    final List<TransactionEntity> recent = items.take(5).toList();

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Giao dịch gần đây',
                  style: context.textStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              if (recent.isNotEmpty)
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w(context),
                      vertical: 4.w(context),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Xem tất cả',
                          style: context.textStyles.bodySmall.copyWith(
                            color: context.colors.pastelIndigoOn,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: context.colors.pastelIndigoOn,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          context.gap.h12,
          if (recent.isEmpty)
            const _RecentEmptyState()
          else
            Column(
              children: <Widget>[
                for (int i = 0; i < recent.length; i++) ...<Widget>[
                  _RecentTransactionTile(transaction: recent[i]),
                  if (i < recent.length - 1)
                    Divider(
                      height: 16.w(context),
                      thickness: 1,
                      color: context.colors.dashboardBackground,
                    ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _RecentTransactionTile extends StatelessWidget {
  const _RecentTransactionTile({required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final bool isExpense = transaction.type == TransactionType.expense;
    final Color color = isExpense
        ? context.colors.expense
        : context.colors.income;
    final Color background = isExpense
        ? context.colors.expenseSurface
        : context.colors.incomeSurface;
    final IconData icon = isExpense
        ? Icons.arrow_outward_rounded
        : Icons.arrow_downward_rounded;

    return Row(
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        context.gap.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                transaction.note?.isNotEmpty == true
                    ? transaction.note!
                    : (isExpense ? 'Khoản chi' : 'Khoản thu'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              context.gap.h2,
              Text(
                DateFormat('dd/MM/yyyy').format(transaction.happenedAt),
                style: context.textStyles.label.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          _formatSignedCurrency(transaction.amount, isExpense: isExpense),
          style: context.textStyles.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _RecentEmptyState extends StatelessWidget {
  const _RecentEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.w(context)),
      child: Column(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: context.colors.pastelIndigo,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: context.colors.pastelIndigoOn,
              size: 28,
            ),
          ),
          context.gap.h12,
          Text(
            'Chưa có giao dịch nào',
            style: context.textStyles.bodyMedium.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          context.gap.h4,
          Text(
            'Hãy thêm khoản thu hoặc chi đầu tiên của bạn nhé.',
            textAlign: TextAlign.center,
            style: context.textStyles.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
