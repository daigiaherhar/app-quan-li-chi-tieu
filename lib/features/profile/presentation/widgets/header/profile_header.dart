part of '../../pages/profile_page.dart';

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w(context), 8.w(context), 16.w(context), 16.w(context)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cá nhân',
                style: context.textStyles.h2.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              _HeaderCircleButton(icon: Icons.settings_rounded, onTap: () {}),
            ],
          ),
          context.gap.h24,
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.primary, width: 2),
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: context.colors.primary.withValues(alpha: 0.15),
                  child: Icon(
                    Icons.person_rounded,
                    size: 36,
                    color: context.colors.primary,
                  ),
                ),
              ),
              context.gap.w16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Người dùng Mobile',
                      style: context.textStyles.h3.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    context.gap.h4,
                    Text(
                      'Dữ liệu lưu trữ nội bộ trên thiết bị',
                      style: context.textStyles.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
