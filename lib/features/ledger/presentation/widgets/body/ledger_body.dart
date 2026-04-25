part of '../../pages/ledger_page.dart';

class _LedgerBody extends StatelessWidget {
  const _LedgerBody({required this.transactions});

  final List<TransactionEntity> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded, size: 64, color: context.colors.textSecondary.withValues(alpha: 0.3)),
            context.gap.h16,
            Text(
              'Không tìm thấy giao dịch nào',
              style: context.textStyles.bodyMedium.copyWith(color: context.colors.textSecondary),
            ),
          ],
        ),
      ).animate().fadeIn();
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w(context), 0, 16.w(context), 120.w(context)),
      itemCount: transactions.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _LedgerTransactionTile(transaction: transactions[index])
            .animate()
            .fadeIn(delay: (index * 50).ms, duration: 400.ms)
            .slideX(begin: 0.1, curve: Curves.easeOutQuad);
      },
    );
  }
}
