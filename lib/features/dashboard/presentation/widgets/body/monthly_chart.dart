part of '../../pages/dashboard_page.dart';

class _MonthlyChartCard extends StatefulWidget {
  const _MonthlyChartCard({required this.items});

  final List<TransactionEntity> items;

  @override
  State<_MonthlyChartCard> createState() => _MonthlyChartCardState();
}

class _MonthlyChartCardState extends State<_MonthlyChartCard> {
  late DateTime _anchor;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _anchor = DateTime(now.year, now.month);
  }

  void _shiftMonth(int delta) {
    setState(() {
      _anchor = DateTime(_anchor.year, _anchor.month + delta);
    });
  }

  List<_WeeklyBucket> _buildBuckets() {
    final int daysInMonth = DateUtils.getDaysInMonth(
      _anchor.year,
      _anchor.month,
    );
    final List<_WeeklyBucket> buckets = List<_WeeklyBucket>.generate(
      4,
      (int index) => _WeeklyBucket(label: 'T${index + 1}'),
    );
    for (final TransactionEntity tx in widget.items) {
      if (tx.happenedAt.year != _anchor.year ||
          tx.happenedAt.month != _anchor.month) {
        continue;
      }
      final int idx = ((tx.happenedAt.day - 1) * 4 ~/ daysInMonth).clamp(0, 3);
      if (tx.type == TransactionType.income) {
        buckets[idx].income += tx.amount;
      } else if (tx.type == TransactionType.expense) {
        buckets[idx].expense += tx.amount;
      }
    }
    return buckets;
  }

  @override
  Widget build(BuildContext context) {
    final List<_WeeklyBucket> buckets = _buildBuckets();
    final bool hasData = buckets.any((_WeeklyBucket b) => b.total > 0);
    final String monthLabel = _formatMonthLabel(_anchor);

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Thống kê tháng',
                      style: context.textStyles.bodyMedium.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    Text(
                      monthLabel,
                      style: context.textStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              _MonthArrowButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => _shiftMonth(-1),
              ),
              context.gap.w8,
              _MonthArrowButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => _shiftMonth(1),
              ),
            ],
          ),
          context.gap.h16,
          if (hasData) ...<Widget>[
            SizedBox(
              height: 140.w(context),
              child: _BarChart(buckets: buckets),
            ),
            context.gap.h12,
            const _ChartLegend(),
          ] else
            const _ChartEmptyState(),
        ],
      ),
    );
  }
}

class _MonthArrowButton extends StatelessWidget {
  const _MonthArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: context.colors.dashboardBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: context.colors.textPrimary, size: 18),
      ),
    );
  }
}

class _WeeklyBucket {
  _WeeklyBucket({required this.label});

  final String label;
  double income = 0;
  double expense = 0;

  double get total => income + expense;
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.buckets});

  final List<_WeeklyBucket> buckets;

  @override
  Widget build(BuildContext context) {
    final double maxValue = buckets
        .map((_WeeklyBucket b) => b.income > b.expense ? b.income : b.expense)
        .fold<double>(0, (double prev, double cur) => cur > prev ? cur : prev);
    final double safeMax = maxValue == 0 ? 1 : maxValue;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: buckets
          .map(
            (_WeeklyBucket b) => Expanded(
              child: _BarGroup(bucket: b, maxValue: safeMax),
            ),
          )
          .toList(),
    );
  }
}

class _BarGroup extends StatelessWidget {
  const _BarGroup({required this.bucket, required this.maxValue});

  final _WeeklyBucket bucket;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: _Bar(
                    value: bucket.income,
                    maxValue: maxValue,
                    color: context.colors.income,
                  ),
                ),
                context.gap.w4,
                Expanded(
                  child: _Bar(
                    value: bucket.expense,
                    maxValue: maxValue,
                    color: context.colors.expense,
                  ),
                ),
              ],
            ),
          ),
          context.gap.h8,
          Text(
            bucket.label,
            style: context.textStyles.label.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.value,
    required this.maxValue,
    required this.color,
  });

  final double value;
  final double maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double ratio = (value / maxValue).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (BuildContext _, BoxConstraints constraints) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          height: constraints.maxHeight * ratio,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[color.withValues(alpha: 0.9), color],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        );
      },
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _LegendDot(color: context.colors.income, label: 'Thu nhập'),
        context.gap.w20,
        _LegendDot(color: context.colors.expense, label: 'Chi tiêu'),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        context.gap.w4,
        Text(
          label,
          style: context.textStyles.label.copyWith(
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ChartEmptyState extends StatelessWidget {
  const _ChartEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.w(context)),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.insert_chart_outlined_rounded,
            size: 40,
            color: context.colors.textSecondary.withValues(alpha: 0.6),
          ),
          context.gap.h8,
          Text(
            'Chưa có dữ liệu trong tháng này',
            style: context.textStyles.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
