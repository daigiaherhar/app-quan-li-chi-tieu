part of '../../pages/wallets_page.dart';

class _WalletSummaryCard extends StatelessWidget {
  const _WalletSummaryCard({required this.totalBalance});

  final double totalBalance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w(context)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: context.colors.heroGradient,
        ),
        borderRadius: BorderRadius.circular(20.w(context)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.colors.heroGradient.first.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Tổng tài sản trong ví',
            style: context.textStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          context.gap.h8,
          Text(
            formatVndCurrency(totalBalance),
            style: context.textStyles.h2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
