part of '../../pages/dashboard_page.dart';

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    final List<_QuickActionData> actions = <_QuickActionData>[
      _QuickActionData(
        icon: Icons.account_balance_wallet_rounded,
        label: 'Ví',
        background: context.colors.pastelMint,
        foreground: context.colors.pastelMintOn,
        onTap: () => context.push(AppRoutePaths.wallets),
      ),
      _QuickActionData(
        icon: Icons.bar_chart_rounded,
        label: 'Báo cáo',
        background: context.colors.pastelAmber,
        foreground: context.colors.pastelAmberOn,
        onTap: () {},
      ),
      _QuickActionData(
        icon: Icons.category_rounded,
        label: 'Hạng mục',
        background: context.colors.pastelPink,
        foreground: context.colors.pastelPinkOn,
        onTap: () {},
      ),
      _QuickActionData(
        icon: Icons.savings_rounded,
        label: 'Ngân sách',
        background: context.colors.pastelMint,
        foreground: context.colors.pastelMintOn,
        onTap: () {},
      ),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columnCount = constraints.maxWidth >= 380 ? 5 : 4;
        final double spacing = 8.w(context);
        final double itemWidth =
            (constraints.maxWidth - spacing * (columnCount - 1)) / columnCount;

        return Row(
          spacing: spacing,
          // runSpacing: 12.w(context),
          // runAlignment: WrapAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions
              .map(
                (_QuickActionData action) => SizedBox(
                  width: itemWidth,
                  child: _QuickActionItem(action: action),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _QuickActionData {
  const _QuickActionData({
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
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({required this.action});

  final _QuickActionData action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action.onTap,
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
                color: action.background,
                borderRadius: BorderRadius.circular(18),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: action.foreground.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(action.icon, color: action.foreground, size: 26),
            ),
            context.gap.h8,
            Text(
              action.label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: context.textStyles.label.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
