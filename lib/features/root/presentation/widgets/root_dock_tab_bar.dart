import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/extension/context_ext.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/features/root/presentation/widgets/root_tab_bar_painter.dart';
import 'package:quan_ly_chi_tieu/shared/widgets/widgets.dart';

part 'root_dock_tab_item.dart';

/// Tab bar dạng dock + notch giữa (theo `centerDocked` + `CustomPaint` trong reference).
class RootDockTabBar extends StatelessWidget {
  const RootDockTabBar({
    super.key,
    required this.tabTitles,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.onCenterPressed,
    this.isCenterOpen = false,
  });

  final List<String> tabTitles;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onCenterPressed;
  final bool isCenterOpen;

  @override
  Widget build(BuildContext context) {
    // Chiều cao TabBar được scale nhưng khống chế tối đa (thông qua .w đã giới hạn 600px)
    // Giảm nhẹ thông số để trông thanh thoát hơn
    final double barHeight = 84.w(context);
    final double paintHeight = 64.w(context);
    
    return Container(
      height: barHeight,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: <Widget>[
          // Lớp nền TabBar dùng CustomPaint
          SizedBox(
            height: paintHeight,
            width: double.infinity,
            child: ClipPath(
              clipper: _RootTabBarClipper(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: CustomPaint(
                  painter: RootTabBarPainter(
                    fillColor: Colors.white.withValues(alpha: 0.7),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.w(context)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: _DockTabItem(
                            icon: Icons.home_rounded,
                            title: tabTitles[0],
                            selected: currentIndex == 0,
                            onTap: () => onIndexChanged(0),
                          ),
                        ),
                        Expanded(
                          child: _DockTabItem(
                            icon: Icons.receipt_long_rounded,
                            title: tabTitles[1],
                            selected: currentIndex == 1,
                            onTap: () => onIndexChanged(1),
                          ),
                        ),
                        const Expanded(child: SizedBox.shrink()),
                        Expanded(
                          child: _DockTabItem(
                            icon: Icons.insights_rounded,
                            title: tabTitles[2],
                            selected: currentIndex == 2,
                            onTap: () => onIndexChanged(2),
                          ),
                        ),
                        Expanded(
                          child: _DockTabItem(
                            icon: Icons.person_outline_rounded,
                            title: tabTitles[3],
                            selected: currentIndex == 3,
                            onTap: () => onIndexChanged(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Nút tròn trung tâm (Liquid Button)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: LiquidCenterButton(
                onPressed: onCenterPressed,
                isOpen: isCenterOpen,
                size: 58.w(context), // Scale nhẹ theo màn hình nhưng không quá to
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(
      begin: 1,
      end: 0,
      duration: 600.ms,
      curve: Curves.easeOutBack,
    );
  }
}

class _RootTabBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double hAll = 0.0;
    const double hGiotNuoc = -0.9;
    const double heSo = 0.0;
    const double wGiotNuoc = 2;
    final Path path0 = Path();

    path0.moveTo(size.width, size.height * hAll);
    path0.cubicTo(
      size.width,
      size.height * hAll,
      size.width,
      size.height * 0.2661356,
      size.width,
      size.height * 0.2937500,
    );
    path0.lineTo(size.width, size.height);
    path0.lineTo(0, size.height);
    path0.lineTo(0, size.height * 0.2937500);
    path0.cubicTo(
      0,
      size.height * 0.2661356,
      0,
      size.height * hAll,
      0,
      size.height * hAll,
    );

    path0.lineTo(
      (size.width * 0.4129555 + heSo) / wGiotNuoc,
      size.height * hAll * hGiotNuoc,
    );
    path0.cubicTo(
      (size.width * 0.4409049 + heSo) / (wGiotNuoc * 0.55),
      size.height * hAll * hGiotNuoc,
      (size.width * 0.4659089 + heSo) / (wGiotNuoc * 0.55),
      size.height * 0.3388869 * hGiotNuoc,
      (size.width * 0.4934028 + heSo),
      size.height * 0.3544106 * hGiotNuoc,
    );
    path0.cubicTo(
      (size.width * 0.4955425 + heSo),
      size.height * 0.3556187 * hGiotNuoc,
      (size.width * 0.4977470 + heSo),
      size.height * 0.3562500 * hGiotNuoc,
      (size.width * 0.5000000 + heSo),
      size.height * 0.3562500 * hGiotNuoc,
    );
    path0.cubicTo(
      (size.width * 0.5022530 + heSo),
      size.height * 0.3562500 * hGiotNuoc,
      size.width * 0.5044575 + heSo,
      size.height * 0.3556187 * hGiotNuoc,
      size.width * 0.5065972 + heSo,
      size.height * 0.3544106 * hGiotNuoc,
    );
    path0.cubicTo(
      (size.width * 0.5340911 + heSo) / (wGiotNuoc * 0.46),
      size.height * 0.3388869 * hGiotNuoc,
      (size.width * 0.5590951 + heSo) / (wGiotNuoc * 0.499),
      size.height * hAll * hGiotNuoc,
      (size.width * 0.5870445 + heSo) * (wGiotNuoc * 0.8),
      size.height * hAll * hGiotNuoc,
    );
    path0.lineTo(size.width * 0.9028340 * heSo, size.height * hAll);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
