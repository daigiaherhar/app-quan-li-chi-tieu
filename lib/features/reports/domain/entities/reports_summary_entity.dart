/// One month bucket for cashflow charts (income + expense).
class MonthlyCashflowPoint {
  const MonthlyCashflowPoint({
    required this.year,
    required this.month,
    required this.monthLabel,
    required this.income,
    required this.expense,
  });

  final int year;
  final int month;
  final String monthLabel;
  final int income;
  final int expense;
}

/// Category spend slice for the reports pie/doughnut chart (expenses).
class CategoryExpensePoint {
  const CategoryExpensePoint({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    this.colorHex,
  });

  final String categoryId;
  final String categoryName;
  final int amount;
  final String? colorHex;
}

/// Month-over-month percent change for the current calendar month.
class MonthOverMonthChange {
  const MonthOverMonthChange({
    required this.incomePercent,
    required this.expensePercent,
    required this.currentIncome,
    required this.currentExpense,
    required this.previousIncome,
    required this.previousExpense,
  });

  /// Null when both current and previous are 0 (no signal).
  final double? incomePercent;
  final double? expensePercent;
  final int currentIncome;
  final int currentExpense;
  final int previousIncome;
  final int previousExpense;
}

/// Aggregated report snapshot for charts and insight rows.
class ReportsSummaryEntity {
  const ReportsSummaryEntity({
    required this.monthlyCashflows,
    required this.categoryExpenses,
    required this.totalIncome,
    required this.totalExpense,
    required this.averageMonthlyIncome,
    required this.averageMonthlyExpense,
    required this.monthOverMonth,
    this.peakExpenseMonth,
  });

  final List<MonthlyCashflowPoint> monthlyCashflows;
  final List<CategoryExpensePoint> categoryExpenses;
  final int totalIncome;
  final int totalExpense;
  final int averageMonthlyIncome;
  final int averageMonthlyExpense;
  final MonthOverMonthChange monthOverMonth;
  final MonthlyCashflowPoint? peakExpenseMonth;

  bool get hasData => totalIncome > 0 || totalExpense > 0;
}
