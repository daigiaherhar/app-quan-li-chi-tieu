part of '../pages/root_page.dart';

class _QuickActionPopup extends StatelessWidget {
  const _QuickActionPopup({required this.onClose, required this.contextGap});

  final VoidCallback onClose;
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
                  label: 'Chi tiêu',
                  icon: Icons.north_east_rounded,
                  color: context.colors.expense,
                  onTap: () {
                    onClose();
                    // TODO: Navigate to Add Expense
                  },
                ).animate().scale(delay: 50.ms, curve: Curves.easeOutBack),
                contextGap.w32,
                _QuickActionPopupItem(
                  label: 'Thu nhập',
                  icon: Icons.south_west_rounded,
                  color: context.colors.income,
                  onTap: () {
                    onClose();
                    // TODO: Navigate to Add Income
                  },
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
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
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
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
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
