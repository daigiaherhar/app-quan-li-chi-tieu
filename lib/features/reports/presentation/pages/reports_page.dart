import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/demo/demo_data.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

part '../widgets/header/reports_header.dart';
part '../widgets/body/reports_body.dart';

/// Tab 2 — Phân tích (feature `reports` + UI demo).
class ReportsPage extends StatelessWidget {
  const ReportsPage({
    super.key,
  });

  static final NumberFormat compact = NumberFormat.compact(locale: 'vi_VN');

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.dashboardBackground,
      child: const SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _ReportsHeader(),
            Expanded(
              child: _ReportsBody(),
            ),
          ],
        ),
      ),
    );
  }
}
