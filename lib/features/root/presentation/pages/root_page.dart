import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/router/app_route_paths.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/presentation/widgets/ocr_transaction_scanner.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transaction_state.dart';
import 'package:quan_ly_chi_tieu/generated/assets.dart';
import 'package:quan_ly_chi_tieu/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/pages/ledger_page.dart';
import 'package:quan_ly_chi_tieu/features/profile/presentation/pages/profile_page.dart';
import 'package:quan_ly_chi_tieu/features/reports/presentation/pages/reports_page.dart';
import 'package:quan_ly_chi_tieu/features/root/presentation/providers/root_providers.dart';
import 'package:quan_ly_chi_tieu/features/root/presentation/providers/root_state.dart';
import 'package:quan_ly_chi_tieu/features/root/presentation/widgets/root_dock_tab_bar.dart';

part '../widgets/quick_action_popup.dart';

/// Root shell: dock tab bar (CustomPaint + center action) + tab pages.
class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  static const List<String> tabTitles = <String>[
    'Trang chủ',
    'Giao dịch',
    'Báo cáo',
    'Cá nhân',
  ];

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  // Dùng GlobalKey để giữ state Tabbar không bị reset khi Stack thay đổi
  final GlobalKey _tabBarKey = GlobalKey();

  void _toggleCenterMenu() {
    ref.read(rootProvider.notifier).toggleCenterMenu();
  }

  void _closeCenterMenu() {
    ref.read(rootProvider.notifier).closeCenterMenu();
  }

  void _showOcrScannerFromCenterMenu() {
    _closeCenterMenu();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      showOcrTransactionScanner(context);
    });
  }

  void _pushTransactionFromCenterMenu(TransactionFlowKind kind) {
    _closeCenterMenu();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.push(AppRoutePaths.transaction, extra: kind);
    });
  }

  @override
  Widget build(BuildContext context) {
    final RootState rootState = ref.watch(rootProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: null, // Tất cả các trang tab tự quản lý Liquid Header
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          IndexedStack(
            index: rootState.currentIndex,
            children: const <Widget>[
              DashboardPage(),
              LedgerPage(),
              ReportsPage(),
              ProfilePage(),
            ],
          ),
          if (rootState.isCenterMenuOpen)
            _QuickActionPopup(
              onClose: _closeCenterMenu,
              onScanReceipt: _showOcrScannerFromCenterMenu,
              onAddExpense: () =>
                  _pushTransactionFromCenterMenu(TransactionFlowKind.expense),
              onAddIncome: () =>
                  _pushTransactionFromCenterMenu(TransactionFlowKind.income),
              contextGap: context.gap,
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RootDockTabBar(
              key: _tabBarKey,
              tabTitles: RootPage.tabTitles,
              currentIndex: rootState.currentIndex,
              isCenterOpen: rootState.isCenterMenuOpen,
              onIndexChanged: (int index) {
                ref.read(rootProvider.notifier).selectTab(index);
              },
              onCenterPressed: _toggleCenterMenu,
            ),
          ),
        ],
      ),
    );
  }
}
