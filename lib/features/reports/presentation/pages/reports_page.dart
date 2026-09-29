import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/utils/app_locale_format.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/features/reports/domain/entities/reports_summary_entity.dart';
import 'package:quan_ly_chi_tieu/features/reports/presentation/providers/reports_providers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

part '../widgets/header/reports_header.dart';
part '../widgets/body/reports_body.dart';

/// Tab 2 — Phân tích chi tiêu (charts từ Drift).
class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  static final NumberFormat compact = NumberFormat.compact(locale: 'vi_VN');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ReportsSummaryEntity> summaryAsync = ref.watch(
      reportsSummaryProvider,
    );

    return ColoredBox(
      color: context.colors.dashboardBackground,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _ReportsHeader(),
            Expanded(
              child: summaryAsync.when(
                data: (ReportsSummaryEntity summary) =>
                    _ReportsBody(summary: summary),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object error, StackTrace stackTrace) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w(context)),
                      child: Text(
                        'Không tải được báo cáo.\n$error',
                        textAlign: TextAlign.center,
                        style: context.textStyles.bodyMedium.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
