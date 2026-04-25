part of '../../pages/reports_page.dart';

class _ReportsHeader extends StatelessWidget {
  const _ReportsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w(context), 8.w(context), 16.w(context), 16.w(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Báo cáo chi tiết',
                style: context.textStyles.h2.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              _HeaderCircleButton(icon: Icons.share_rounded, onTap: () {}),
            ],
          ),
          context.gap.h8,
          Text(
            'Phân tích chi tiêu hàng tháng của bạn.',
            style: context.textStyles.bodySmall.copyWith(
              color: context.colors.textSecondary,
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
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: context.colors.cardSurface.withValues(alpha: 0.6),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: context.colors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: InkWell(
            onTap: onTap,
            child: Icon(icon, color: context.colors.textPrimary, size: 20),
          ),
        ),
      ),
    );
  }
}
