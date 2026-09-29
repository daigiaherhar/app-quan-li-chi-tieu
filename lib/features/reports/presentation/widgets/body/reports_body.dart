part of '../../pages/reports_page.dart';

class _ReportsBody extends StatelessWidget {
  const _ReportsBody({required this.summary});

  final ReportsSummaryEntity summary;

  static const List<Color> _fallbackPalette = <Color>[
    AppColorsStatic.primary,
    AppColorsStatic.chartOrange,
    AppColorsStatic.chartPurple,
    AppColorsStatic.chartBlueGrey,
    AppColorsStatic.incomePositive,
    Color(0xFF0EA5E9),
    Color(0xFFE11D48),
  ];

  @override
  Widget build(BuildContext context) {
    if (!summary.hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.pie_chart_outline_rounded,
              size: 64,
              color: context.colors.textSecondary.withValues(alpha: 0.3),
            ),
            context.gap.h16,
            Text(
              'Chưa có dữ liệu thu/chi để phân tích',
              style: context.textStyles.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final MonthlyCashflowPoint? peak = summary.peakExpenseMonth;
    final String peakLabel = peak == null
        ? '—'
        : '${peak.monthLabel} · ${ReportsPage.compact.format(peak.expense)}';
    final MonthOverMonthChange mom = summary.monthOverMonth;
    final MonthlyCashflowPoint currentMonth = summary.monthlyCashflows.last;
    final DateTime currentMonthDate = DateTime(
      currentMonth.year,
      currentMonth.month,
    );
    final int currentNet = currentMonth.income - currentMonth.expense;
    final List<_CashflowSlice> currentMonthSlices = <_CashflowSlice>[
      _CashflowSlice(label: 'Thu', amount: currentMonth.income),
      _CashflowSlice(label: 'Chi', amount: currentMonth.expense),
    ].where((_CashflowSlice slice) => slice.amount > 0).toList(growable: false);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        16.w(context),
        0,
        16.w(context),
        120.w(context),
      ),
      children: <Widget>[
        _ChartCard(
          title: 'Tổng thu chi · ${formatMonthYearVi(currentMonthDate)}',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 240,
                child: currentMonthSlices.isEmpty
                    ? Center(
                        child: Text(
                          'Chưa có thu/chi tháng này',
                          style: context.textStyles.bodyMedium.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      )
                    : SfCircularChart(
                        margin: EdgeInsets.zero,
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          textStyle: TextStyle(
                            color: context.colors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <DoughnutSeries<_CashflowSlice, String>>[
                          DoughnutSeries<_CashflowSlice, String>(
                            animationDuration: 0,
                            dataSource: currentMonthSlices,
                            xValueMapper: (_CashflowSlice d, int _) => d.label,
                            yValueMapper: (_CashflowSlice d, int _) => d.amount,
                            pointColorMapper: (_CashflowSlice d, int _) =>
                                d.label == 'Thu'
                                ? context.colors.income
                                : context.colors.expense,
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: false,
                            ),
                            innerRadius: '62%',
                            radius: '78%',
                          ),
                        ],
                        annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            widget: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Còn lại',
                                  style: context.textStyles.label.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                                Text(
                                  ReportsPage.compact.format(currentNet),
                                  style: context.textStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: currentNet >= 0
                                        ? context.colors.income
                                        : context.colors.expense,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              context.gap.h8,
              Row(
                children: <Widget>[
                  Expanded(
                    child: _MonthTotalTile(
                      label: 'Tổng thu',
                      value: formatAppCurrency(currentMonth.income),
                      color: context.colors.income,
                    ),
                  ),
                  context.gap.w8,
                  Expanded(
                    child: _MonthTotalTile(
                      label: 'Tổng chi',
                      value: formatAppCurrency(currentMonth.expense),
                      color: context.colors.expense,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        context.gap.h16,
        _ChartCard(
          title: 'Thu & chi theo tháng',
          child: SizedBox(
            height: 280,
            child: SfCartesianChart(
              enableAxisAnimation: false,
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: 12,
                ),
              ),
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
                format: 'series.name · point.x : point.y',
              ),
              series: <ColumnSeries<MonthlyCashflowPoint, String>>[
                ColumnSeries<MonthlyCashflowPoint, String>(
                  name: 'Thu',
                  animationDuration: 0,
                  dataSource: summary.monthlyCashflows,
                  xValueMapper: (MonthlyCashflowPoint d, int _) => d.monthLabel,
                  yValueMapper: (MonthlyCashflowPoint d, int _) => d.income,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  color: context.colors.income,
                  width: 0.7,
                  spacing: 0.2,
                ),
                ColumnSeries<MonthlyCashflowPoint, String>(
                  name: 'Chi',
                  animationDuration: 0,
                  dataSource: summary.monthlyCashflows,
                  xValueMapper: (MonthlyCashflowPoint d, int _) => d.monthLabel,
                  yValueMapper: (MonthlyCashflowPoint d, int _) => d.expense,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  color: context.colors.expense,
                  width: 0.7,
                  spacing: 0.2,
                ),
              ],
            ),
          ),
        ),
        context.gap.h16,
        _MomCompareCard(monthOverMonth: mom),
        context.gap.h16,
        if (summary.categoryExpenses.isNotEmpty)
          _ChartCard(
            title: 'Chi theo danh mục',
            child: SizedBox(
              height: 280,
              child: SfCircularChart(
                margin: EdgeInsets.zero,
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                  textStyle: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <DoughnutSeries<CategoryExpensePoint, String>>[
                  DoughnutSeries<CategoryExpensePoint, String>(
                    animationDuration: 0,
                    dataSource: summary.categoryExpenses,
                    xValueMapper: (CategoryExpensePoint d, int _) =>
                        d.categoryName,
                    yValueMapper: (CategoryExpensePoint d, int _) => d.amount,
                    pointColorMapper: (CategoryExpensePoint d, int index) =>
                        _resolveCategoryColor(d, index),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: false,
                    ),
                    innerRadius: '62%',
                    radius: '78%',
                  ),
                ],
                annotations: <CircularChartAnnotation>[
                  CircularChartAnnotation(
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Tổng chi',
                          style: context.textStyles.label.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        Text(
                          ReportsPage.compact.format(summary.totalExpense),
                          style: context.textStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (summary.categoryExpenses.isNotEmpty) context.gap.h16,
        _ReportsInsightRow(title: 'Chi cao nhất', value: peakLabel),
        context.gap.h8,
        _ReportsInsightRow(
          title: 'Trung bình thu / tháng',
          value: ReportsPage.compact.format(summary.averageMonthlyIncome),
        ),
        context.gap.h8,
        _ReportsInsightRow(
          title: 'Trung bình chi / tháng',
          value: ReportsPage.compact.format(summary.averageMonthlyExpense),
        ),
        context.gap.h8,
        _ReportsInsightRow(
          title: 'Tổng thu 6 tháng',
          value: formatAppCurrency(summary.totalIncome),
        ),
        context.gap.h8,
        _ReportsInsightRow(
          title: 'Tổng chi 6 tháng',
          value: formatAppCurrency(summary.totalExpense),
        ),
      ],
    );
  }

  Color _resolveCategoryColor(CategoryExpensePoint point, int index) {
    final String? hex = point.colorHex;
    if (hex != null && hex.isNotEmpty) {
      final Color? parsed = _tryParseHexColor(hex);
      if (parsed != null) {
        return parsed;
      }
    }
    return _fallbackPalette[index % _fallbackPalette.length];
  }

  Color? _tryParseHexColor(String raw) {
    String hex = raw.trim();
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    if (hex.length != 8) {
      return null;
    }
    final int? value = int.tryParse(hex, radix: 16);
    if (value == null) {
      return null;
    }
    return Color(value);
  }
}

class _CashflowSlice {
  const _CashflowSlice({required this.label, required this.amount});

  final String label;
  final int amount;
}

class _MonthTotalTile extends StatelessWidget {
  const _MonthTotalTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: context.textStyles.label.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            context.gap.h4,
            Text(
              value,
              style: context.textStyles.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MomCompareCard extends StatelessWidget {
  const _MomCompareCard({required this.monthOverMonth});

  final MonthOverMonthChange monthOverMonth;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: context.padding.all16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'So với tháng trước',
              style: context.textStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            context.gap.h12,
            _MomRow(
              label: 'Thu nhập',
              percent: monthOverMonth.incomePercent,
              currentAmount: monthOverMonth.currentIncome,
              positiveIsGood: true,
            ),
            context.gap.h10,
            _MomRow(
              label: 'Chi tiêu',
              percent: monthOverMonth.expensePercent,
              currentAmount: monthOverMonth.currentExpense,
              positiveIsGood: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _MomRow extends StatelessWidget {
  const _MomRow({
    required this.label,
    required this.percent,
    required this.currentAmount,
    required this.positiveIsGood,
  });

  final String label;
  final double? percent;
  final int currentAmount;
  final bool positiveIsGood;

  @override
  Widget build(BuildContext context) {
    final String percentText = _formatPercent(percent);
    final Color percentColor = _percentColor(context, percent);

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              Text(
                formatAppCurrency(currentAmount),
                style: context.textStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: percentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            percentText,
            style: context.textStyles.bodySmall.copyWith(
              color: percentColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  String _formatPercent(double? value) {
    if (value == null) {
      return '—';
    }
    final String sign = value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(value.abs() >= 10 ? 0 : 1)}%';
  }

  Color _percentColor(BuildContext context, double? value) {
    if (value == null || value == 0) {
      return context.colors.textSecondary;
    }
    final bool isUp = value > 0;
    if (positiveIsGood) {
      return isUp ? context.colors.income : context.colors.expense;
    }
    return isUp ? context.colors.expense : context.colors.income;
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: context.padding.all12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              title,
              style: context.textStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            context.gap.h12,
            child,
          ],
        ),
      ),
    );
  }
}

class _ReportsInsightRow extends StatelessWidget {
  const _ReportsInsightRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
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
