part of '../../pages/profile_page.dart';

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: context.padding.h16,
      children: const <Widget>[
        _ProfileMoreTile(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Ví & tài khoản',
          subtitle: 'Quản lý nhiều ví',
        ),
        _ProfileMoreTile(
          icon: Icons.savings_outlined,
          title: 'Ngân sách',
          subtitle: 'Giới hạn theo danh mục',
        ),
        _ProfileMoreTile(
          icon: Icons.notifications_none_rounded,
          title: 'Nhắc nhở',
          subtitle: 'Nhập liệu định kỳ',
        ),
        _ProfileMoreTile(
          icon: Icons.settings_outlined,
          title: 'Cài đặt',
          subtitle: 'Ngôn ngữ, chủ đề',
        ),
      ],
    );
  }
}

class _ProfileMoreTile extends StatelessWidget {
  const _ProfileMoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.w(context)),
      child: Material(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Padding(
            padding: context.padding.all16,
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: context.colors.primary,
                ),
                context.gap.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: context.textStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      context.gap.h4,
                      Text(
                        subtitle,
                        style: context.textStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
