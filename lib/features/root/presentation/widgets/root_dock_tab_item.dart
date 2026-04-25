part of 'root_dock_tab_bar.dart';

class _DockTabItem extends StatelessWidget {
  const _DockTabItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color itemColor =
        selected ? context.colors.primary : AppColorsStatic.textSecondary;
    return Tooltip(
      message: title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedScale(
          scale: selected ? 1.08 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(icon, color: itemColor, size: 24),
              context.gap.h2,
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: context.textStyles.label.copyWith(
                  color: itemColor,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              context.gap.h8,
            ],
          ),
        ),
      ),
    );
  }
}
