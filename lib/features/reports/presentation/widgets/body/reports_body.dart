part of '../../pages/reports_page.dart';

class _ReportsBody extends StatelessWidget {
  const _ReportsBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: context.padding.h16,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.colors.border,
            ),
          ),
          child: Padding(
            padding: context.padding.all12,
            child: SizedBox(
              height: 280,
              child: SfCartesianChart(
                enableAxisAnimation: false,
                margin: EdgeInsets.zero,
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  labelStyle: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  numberFormat: ReportsPage.compact,
                  majorGridLines: MajorGridLines(
                    width: 1,
                    color: context.colors.divider,
                  ),
                  axisLine: const AxisLine(width: 0),
                  labelStyle: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'point.x : point.y',
                ),
                series: <ColumnSeries<MonthlySpend, String>>[
                  ColumnSeries<MonthlySpend, String>(
                    animationDuration: 0,
                    dataSource: kMockMonthlySpends,
                    xValueMapper: (MonthlySpend d, _) => d.monthLabel,
                    yValueMapper: (MonthlySpend d, _) => d.expense,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    color: context.colors.primary.withValues(alpha: 0.9),
                    width: 0.55,
                  ),
                ],
              ),
            ),
          ),
        ),
        context.gap.h16,
        _ReportsInsightRow(
          title: 'Chi cao nhất',
          value: 'T4 · ${ReportsPage.compact.format(8_450_000)}',
        ),
        context.gap.h8,
        _ReportsInsightRow(
          title: 'Trung bình 6 tháng',
          value: ReportsPage.compact.format(7_308_333),
        ),
      ],
    );
  }
}

class _ReportsInsightRow extends StatelessWidget {
  const _ReportsInsightRow({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.colors.border,
        ),
      ),
      child: Padding(
        padding: context.padding.all16,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
            Text(
              value,
              style: context.textStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
