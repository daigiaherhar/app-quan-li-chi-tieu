enum TransactionType {
  income,
  expense,
  transfer,
}

class TransactionEntity {
  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.happenedAt,
    this.note,
    this.categoryId,
    this.walletId = 'default',
  });

  final String id;
  final TransactionType type;
  final double amount;
  final DateTime happenedAt;
  final String? note;
  final String? categoryId;
  final String walletId;

  bool get isExpense => type == TransactionType.expense;
  bool get isIncome => type == TransactionType.income;
}
