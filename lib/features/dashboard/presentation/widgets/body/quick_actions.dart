part of '../../pages/dashboard_page.dart';

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _QuickActionItem(
          icon: Icons.account_balance_wallet_rounded,
          label: 'Ví',
          background: context.colors.pastelIndigo,
          foreground: context.colors.pastelIndigoOn,
          onTap: () {},
        ),
        _QuickActionItem(
          icon: Icons.bar_chart_rounded,
          label: 'Báo cáo',
          background: context.colors.pastelAmber,
          foreground: context.colors.pastelAmberOn,
          onTap: () {},
        ),
        _QuickActionItem(
          icon: Icons.category_rounded,
          label: 'Hạng mục',
          background: context.colors.pastelPink,
          foreground: context.colors.pastelPinkOn,
          onTap: () {},
        ),
        _QuickActionItem(
          icon: Icons.savings_rounded,
          label: 'Ngân sách',
          background: context.colors.pastelMint,
          foreground: context.colors.pastelMintOn,
          onTap: () {},
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 6.w(context),
          vertical: 6.w(context),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: foreground, size: 26),
            ),
            context.gap.h8,
            Text(
              label,
              style: context.textStyles.label.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
