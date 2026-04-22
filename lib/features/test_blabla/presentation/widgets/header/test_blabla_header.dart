part of '../../pages/test_blabla_page.dart';

class _TestBlablaHeader extends StatelessWidget implements PreferredSizeWidget {
  const _TestBlablaHeader({
    required this.title,
  });

  final String title;

  @override
  Widget build(
    BuildContext context,
  ) {
    return BaseAppBar(
      title: title,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
        kToolbarHeight,
      );
}
