import 'package:quan_ly_chi_tieu/features/reports/data/datasources/reports_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/reports/data/models/reports_transaction_model.dart';
import 'package:quan_ly_chi_tieu/features/reports/domain/entities/reports_summary_entity.dart';
import 'package:quan_ly_chi_tieu/features/reports/domain/repositories/reports_repository.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl(this._localDataSource);

  static const int _monthWindow = 6;

  final ReportsLocalDataSource _localDataSource;

  @override
  Stream<ReportsSummaryEntity> watchSummary() {
    return _localDataSource.watchTransactions().map(_aggregate);
  }

  ReportsSummaryEntity _aggregate(List<ReportsTransactionModel> transactions) {
    final DateTime now = DateTime.now();
    final DateTime windowStart = DateTime(
      now.year,
      now.month - (_monthWindow - 1),
    );

    final List<MonthlyCashflowPoint> monthly = <MonthlyCashflowPoint>[];
    for (int offset = _monthWindow - 1; offset >= 0; offset--) {
      final DateTime monthDate = DateTime(now.year, now.month - offset);
      monthly.add(
        MonthlyCashflowPoint(
          year: monthDate.year,
          month: monthDate.month,
          monthLabel: 'T${monthDate.month}',
          income: 0,
          expense: 0,
        ),
      );
    }

    final Map<String, _CategoryBucket> expenseCategories =
        <String, _CategoryBucket>{};
    int totalIncome = 0;
    int totalExpense = 0;

    for (final ReportsTransactionModel tx in transactions) {
      final DateTime happened = tx.happenedAt;
      if (happened.isBefore(windowStart)) {
        continue;
      }

      for (int index = 0; index < monthly.length; index++) {
        final MonthlyCashflowPoint point = monthly[index];
        if (point.year != happened.year || point.month != happened.month) {
          continue;
        }
        if (tx.isIncome) {
          totalIncome += tx.amount;
          monthly[index] = MonthlyCashflowPoint(
            year: point.year,
            month: point.month,
            monthLabel: point.monthLabel,
            income: point.income + tx.amount,
            expense: point.expense,
          );
        } else if (tx.isExpense) {
          totalExpense += tx.amount;
          monthly[index] = MonthlyCashflowPoint(
            year: point.year,
            month: point.month,
            monthLabel: point.monthLabel,
            income: point.income,
            expense: point.expense + tx.amount,
          );
          final String categoryId = tx.categoryId ?? 'uncategorized';
          final String categoryName = tx.categoryName ?? 'Khác';
          final _CategoryBucket? existing = expenseCategories[categoryId];
          if (existing == null) {
            expenseCategories[categoryId] = _CategoryBucket(
              categoryId: categoryId,
              categoryName: categoryName,
              colorHex: tx.colorHex,
              amount: tx.amount,
            );
          } else {
            expenseCategories[categoryId] = existing.copyWith(
              amount: existing.amount + tx.amount,
            );
          }
        }
        break;
      }
    }

    final List<CategoryExpensePoint> categoryExpenses = expenseCategories.values
        .map(
          (_CategoryBucket bucket) => CategoryExpensePoint(
            categoryId: bucket.categoryId,
            categoryName: bucket.categoryName,
            amount: bucket.amount,
            colorHex: bucket.colorHex,
          ),
        )
        .toList();
    categoryExpenses.sort(
      (CategoryExpensePoint a, CategoryExpensePoint b) =>
          b.amount.compareTo(a.amount),
    );

    MonthlyCashflowPoint? peakExpenseMonth;
    for (final MonthlyCashflowPoint point in monthly) {
      if (peakExpenseMonth == null ||
          point.expense > peakExpenseMonth.expense) {
        peakExpenseMonth = point;
      }
    }
    if (peakExpenseMonth != null && peakExpenseMonth.expense <= 0) {
      peakExpenseMonth = null;
    }

    final MonthlyCashflowPoint currentMonth = monthly.last;
    final MonthlyCashflowPoint previousMonth = monthly[monthly.length - 2];

    return ReportsSummaryEntity(
      monthlyCashflows: monthly,
      categoryExpenses: categoryExpenses,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      averageMonthlyIncome: (totalIncome / _monthWindow).round(),
      averageMonthlyExpense: (totalExpense / _monthWindow).round(),
      monthOverMonth: MonthOverMonthChange(
        incomePercent: _percentChange(
          previous: previousMonth.income,
          current: currentMonth.income,
        ),
        expensePercent: _percentChange(
          previous: previousMonth.expense,
          current: currentMonth.expense,
        ),
        currentIncome: currentMonth.income,
        currentExpense: currentMonth.expense,
        previousIncome: previousMonth.income,
        previousExpense: previousMonth.expense,
      ),
      peakExpenseMonth: peakExpenseMonth,
    );
  }

  double? _percentChange({required int previous, required int current}) {
    if (previous == 0 && current == 0) {
      return null;
    }
    if (previous == 0) {
      return 100;
    }
    return ((current - previous) / previous) * 100;
  }
}

class _CategoryBucket {
  const _CategoryBucket({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    this.colorHex,
  });

  final String categoryId;
  final String categoryName;
  final int amount;
  final String? colorHex;

  _CategoryBucket copyWith({
    String? categoryId,
    String? categoryName,
    int? amount,
    String? colorHex,
  }) {
    return _CategoryBucket(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}
