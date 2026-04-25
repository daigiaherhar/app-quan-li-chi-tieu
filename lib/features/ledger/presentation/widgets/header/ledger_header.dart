part of '../../pages/ledger_page.dart';

class _LedgerHeader extends StatelessWidget {
  const _LedgerHeader({
    required this.chipIndex,
    required this.onChipChanged,
  });

  final int chipIndex;
  final ValueChanged<int> onChipChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w(context), 12.w(context), 20.w(context), 20.w(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: kToolbarHeight * 0.5),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sổ giao dịch',
                      style: context.textStyles.h2.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                      ),
                    ),
                    Text(
                      'Quản lý dòng tiền của bạn',
                      style: context.textStyles.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _HeaderCircleButton(icon: Icons.search_rounded, onTap: () {}),
              context.gap.w12,
              _HeaderCircleButton(icon: Icons.calendar_today_rounded, onTap: () {}),
            ],
          ),
          context.gap.h24,
          _LiquidSegmentedControl(
            currentIndex: chipIndex,
            onIndexChanged: onChipChanged,
            labels: const ['Tất cả', 'Chi tiêu', 'Thu nhập'],
          ),
        ],
      ),
    ).animate().slideY(begin: -0.1, duration: 600.ms, curve: Curves.easeOutCubic).fadeIn();
  }
}

class _LiquidSegmentedControl extends StatelessWidget {
  const _LiquidSegmentedControl({
    required this.currentIndex,
    required this.onIndexChanged,
    required this.labels,
  });

  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.w(context),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: context.colors.cardSurface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Sliding Indicator
          AnimatedAlign(
            duration: 300.ms,
            curve: Curves.easeInOutBack,
            alignment: Alignment(
              -1 + (currentIndex * (2 / (labels.length - 1))),
              0,
            ),
            child: FractionallySizedBox(
              widthFactor: 1 / labels.length,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.primary.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Labels
          Row(
            children: List.generate(
              labels.length,
              (index) => Expanded(
                child: GestureDetector(
                  onTap: () => onIndexChanged(index),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: 300.ms,
                      style: context.textStyles.bodySmall.copyWith(
                        color: currentIndex == index ? Colors.white : context.colors.textSecondary,
                        fontWeight: currentIndex == index ? FontWeight.w800 : FontWeight.w600,
                      ),
                      child: Text(labels[index]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: context.colors.cardSurface.withValues(alpha: 0.5),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: context.colors.cardShadow,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: InkWell(
            onTap: onTap,
            child: Icon(icon, color: context.colors.textPrimary, size: 22),
          ),
        ),
      ),
    );
  }
}
