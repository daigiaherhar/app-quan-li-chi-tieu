part of '../pages/root_page.dart';

class _QuickActionPopup extends StatelessWidget {
  const _QuickActionPopup({
    required this.onClose,
    required this.onScanReceipt,
    required this.onAddExpense,
    required this.onAddIncome,
    required this.contextGap,
  });

  final VoidCallback onClose;
  final VoidCallback onScanReceipt;
  final VoidCallback onAddExpense;
  final VoidCallback onAddIncome;
  final AppGapScheme contextGap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withValues(alpha: 0.2),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: const SizedBox.expand(),
              ),
            ),
          ).animate().fadeIn(duration: 200.ms),
        ),
        Positioned(
          bottom: 100.w(context),
          left: 0,
          right: 0,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _QuickActionPopupItem(
                  label: 'Quét HĐ',
                  color: Colors.indigo,
                  icon: Icons.document_scanner_rounded,
                  backgroundColor: context.colors.white,
                  onTap: onScanReceipt,
                ).animate().scale(delay: 150.ms, curve: Curves.easeOutBack),
                contextGap.w32,
                _QuickActionPopupItem(
                  label: 'Chi tiêu',
                  svgAssetPath: Assets.assetIcons.iconChi,
                  color: context.colors.expense,
                  backgroundColor: context.colors.expenseSurface,
                  onTap: onAddExpense,
                ).animate().scale(delay: 50.ms, curve: Curves.easeOutBack),
                contextGap.w32,
                _QuickActionPopupItem(
                  label: 'Thu nhập',
                  svgAssetPath: Assets.assetIcons.iconThu,
                  color: context.colors.income,
                  backgroundColor: context.colors.incomeSurface,
                  onTap: onAddIncome,
                ).animate().scale(delay: 150.ms, curve: Curves.easeOutBack),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionPopupItem extends StatelessWidget {
  const _QuickActionPopupItem({
    required this.label,
    this.svgAssetPath,
    this.icon,
    required this.color,
    this.backgroundColor,
    required this.onTap,
  });

  final String label;
  final String? svgAssetPath;
  final IconData? icon;
  final Color color;
  final Color? backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: backgroundColor ?? context.colors.white,

                borderRadius: context.sizes.r14,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: svgAssetPath?.isNotEmpty ?? false
                    ? SvgPicture.asset(
                        svgAssetPath!,
                        width: 34,
                        height: 34,
                        fit: BoxFit.contain,
                      )
                    : icon != null
                    ? Icon(icon, size: 34, color: color)
                    : const SizedBox(),
              ),
            ),
          ),
        ),
        context.gap.h8,
        Text(
          label,
          style: context.textStyles.bodySmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              const Shadow(
                color: Colors.black45,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
