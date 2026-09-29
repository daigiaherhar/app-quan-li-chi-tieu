import 'package:quan_ly_chi_tieu/core/database/app_database.dart';

/// Transaction row used to build reports aggregations.
class ReportsTransactionModel {
  const ReportsTransactionModel({
    required this.type,
    required this.amount,
    required this.happenedAt,
    this.categoryId,
    this.categoryName,
    this.colorHex,
  });

  factory ReportsTransactionModel.fromDrift(
    Transaction row, {
    CategoryTransaction? category,
  }) {
    return ReportsTransactionModel(
      type: row.type,
      amount: row.amount,
      happenedAt: DateTime.parse(row.happenedAt).toLocal(),
      categoryId: row.categoryId,
      categoryName: category?.name,
      colorHex: category?.colorHex,
    );
  }

  final String type;
  final int amount;
  final DateTime happenedAt;
  final String? categoryId;
  final String? categoryName;
  final String? colorHex;

  bool get isIncome => type == kTransactionTypeIncome;

  bool get isExpense => type == kTransactionTypeExpense;
}
