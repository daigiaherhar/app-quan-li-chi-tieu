import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';

/// Data-layer read model for ledger transaction rows.
class LedgerTransactionModel {
  const LedgerTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.happenedAt,
    required this.walletId,
    this.note,
    this.categoryId,
    this.categoryName,
  });

  factory LedgerTransactionModel.fromDrift(
    Transaction row, {
    String? categoryName,
  }) {
    return LedgerTransactionModel(
      id: row.id,
      type: row.type,
      amount: row.amount,
      happenedAt: DateTime.parse(row.happenedAt).toLocal(),
      walletId: row.walletId,
      note: row.note,
      categoryId: row.categoryId,
      categoryName: categoryName,
    );
  }

  final String id;
  final String type;
  final int amount;
  final DateTime happenedAt;
  final String walletId;
  final String? note;
  final String? categoryId;
  final String? categoryName;
}

extension LedgerTransactionModelToEntity on LedgerTransactionModel {
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      type: _mapType(type),
      amount: amount.toDouble(),
      happenedAt: happenedAt,
      note: note,
      categoryId: categoryId,
      walletId: walletId,
      nameCategory: categoryName,
    );
  }

  TransactionType _mapType(String rawType) {
    return switch (rawType) {
      kTransactionTypeIncome => TransactionType.income,
      kTransactionTypeExpense => TransactionType.expense,
      _ => TransactionType.transfer,
    };
  }
}
