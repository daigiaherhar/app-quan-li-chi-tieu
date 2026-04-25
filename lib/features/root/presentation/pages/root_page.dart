import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/pages/ledger_page.dart';
import 'package:quan_ly_chi_tieu/features/profile/presentation/pages/profile_page.dart';
import 'package:quan_ly_chi_tieu/features/reports/presentation/pages/reports_page.dart';
import 'package:quan_ly_chi_tieu/features/root/presentation/widgets/root_dock_tab_bar.dart';

part '../widgets/quick_action_popup.dart';

/// Root shell: dock tab bar (CustomPaint + center action) + tab pages.
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  static const List<String> tabTitles = <String>[
    'Trang chủ',
    'Giao dịch',
    'Báo cáo',
    'Cá nhân',
  ];

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _tabIndex = 0;
  bool _isCenterMenuOpen = false;

  // Dùng GlobalKey để giữ state Tabbar không bị reset khi Stack thay đổi
  final GlobalKey _tabBarKey = GlobalKey();

  void _toggleCenterMenu() {
    setState(() {
      _isCenterMenuOpen = !_isCenterMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: null, // Tất cả các trang tab tự quản lý Liquid Header
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          IndexedStack(
            index: _tabIndex,
            children: const <Widget>[
              DashboardPage(),
              LedgerPage(),
              ReportsPage(),
              ProfilePage(),
            ],
          ),
          if (_isCenterMenuOpen)
            _QuickActionPopup(
              onClose: _toggleCenterMenu,
              contextGap: context.gap,
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RootDockTabBar(
              key: _tabBarKey,
              tabTitles: RootPage.tabTitles,
              currentIndex: _tabIndex,
              isCenterOpen: _isCenterMenuOpen,
              onIndexChanged: (int index) {
                if (_isCenterMenuOpen) _toggleCenterMenu();
                setState(() => _tabIndex = index);
              },
              onCenterPressed: _toggleCenterMenu,
            ),
          ),
        ],
      ),
    );
  }
}
