import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';

/// Demo-only data for tab UI.
class CategorySpend {
  const CategorySpend({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;
}

class MonthlySpend {
  const MonthlySpend({
    required this.monthLabel,
    required this.expense,
  });

  final String monthLabel;
  final double expense;
}

List<CategorySpend> mockCategorySpends() {
  return <CategorySpend>[
    const CategorySpend(
      label: 'Ăn uống',
      amount: 3200000,
      color: AppColorsStatic.primary,
    ),
    const CategorySpend(
      label: 'Di chuyển',
      amount: 900000,
      color: AppColorsStatic.incomePositive,
    ),
    const CategorySpend(
      label: 'Mua sắm',
      amount: 1450000,
      color: AppColorsStatic.chartOrange,
    ),
    const CategorySpend(
      label: 'Hóa đơn',
      amount: 2100000,
      color: AppColorsStatic.chartPurple,
    ),
    const CategorySpend(
      label: 'Khác',
      amount: 650000,
      color: AppColorsStatic.chartBlueGrey,
    ),
  ];
}

const List<MonthlySpend> kMockMonthlySpends = <MonthlySpend>[
  MonthlySpend(monthLabel: 'T11', expense: 6200000),
  MonthlySpend(monthLabel: 'T12', expense: 7800000),
  MonthlySpend(monthLabel: 'T1', expense: 5900000),
  MonthlySpend(monthLabel: 'T2', expense: 8400000),
  MonthlySpend(monthLabel: 'T3', expense: 7100000),
  MonthlySpend(monthLabel: 'T4', expense: 8450000),
];

final List<TransactionEntity> kMockTransactions = [
  TransactionEntity(
    id: '1',
    type: TransactionType.expense,
    amount: 420000,
    happenedAt: DateTime.now(),
    note: 'Siêu thị CoopMart',
    categoryId: 'Ăn uống',
  ),
  TransactionEntity(
    id: '2',
    type: TransactionType.income,
    amount: 18500000,
    happenedAt: DateTime.now().subtract(const Duration(days: 1)),
    note: 'Lương tháng 4',
    categoryId: 'Tiền lương',
  ),
  TransactionEntity(
    id: '3',
    type: TransactionType.expense,
    amount: 85000,
    happenedAt: DateTime.now().subtract(const Duration(days: 1)),
    note: 'GrabBike đi làm',
    categoryId: 'Di chuyển',
  ),
  TransactionEntity(
    id: '4',
    type: TransactionType.expense,
    amount: 199000,
    happenedAt: DateTime.now().subtract(const Duration(days: 4)),
    note: 'Gói cước 4G',
    categoryId: 'Hóa đơn',
  ),
  TransactionEntity(
    id: '5',
    type: TransactionType.expense,
    amount: 1200000,
    happenedAt: DateTime.now().subtract(const Duration(days: 10)),
    note: 'Mua giày mới',
    categoryId: 'Mua sắm',
  ),
  TransactionEntity(
    id: '6',
    type: TransactionType.income,
    amount: 500000,
    happenedAt: DateTime.now().subtract(const Duration(days: 2)),
    note: 'Tiền lãi tiết kiệm',
    categoryId: 'Đầu tư',
  ),
  TransactionEntity(
    id: '7',
    type: TransactionType.expense,
    amount: 55000,
    happenedAt: DateTime.now().subtract(const Duration(days: 0)),
    note: 'Cà phê sáng',
    categoryId: 'Ăn uống',
  ),
];
