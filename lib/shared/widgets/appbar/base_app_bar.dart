import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.backgroundColor,
    this.titleColor = AppColorsStatic.onPrimary,
    this.elevation = 0,
    this.actions,
    this.leading,
  });

  final String title;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color titleColor;
  final double elevation;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(
    BuildContext context,
  ) {
    return AppBar(
      backgroundColor: backgroundColor ?? context.colors.primary,
      centerTitle: centerTitle,
      elevation: elevation,
      actions: actions,
      leading: leading,
      title: Text(
        title,
        style: context.textStyles.h2.copyWith(
          color: titleColor,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
        kToolbarHeight,
      );
}
