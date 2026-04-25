part of '../../pages/ledger_page.dart';

class _LedgerTransactionTile extends StatelessWidget {
  const _LedgerTransactionTile({required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final bool isExpense = transaction.isExpense;
    final Color color = isExpense ? context.colors.expense : context.colors.income;
    final Color background =
        isExpense ? context.colors.expenseSurface : context.colors.incomeSurface;
    final IconData icon =
        isExpense ? Icons.arrow_outward_rounded : Icons.arrow_downward_rounded;

    final String amountSign = isExpense ? '-' : '+';
    final String amountText = '$amountSign${LedgerPage.currency.format(transaction.amount)}';

    return Container(
      margin: EdgeInsets.only(bottom: 12.w(context)),
      decoration: BoxDecoration(
        color: context.colors.cardSurface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: context.colors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 24),
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
                        '${transaction.categoryId ?? "Khác"} · ${DateFormat('dd/MM/yyyy').format(transaction.happenedAt)}',
                        style: context.textStyles.label.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  amountText,
                  style: context.textStyles.bodyMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
