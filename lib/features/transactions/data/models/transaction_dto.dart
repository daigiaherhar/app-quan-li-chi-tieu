import 'package:drift/drift.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';

class TransactionDto {
  const TransactionDto({
    required this.amount,
    required this.type,
    this.categoryId,
    required this.note,
    required this.happenedAt,
    this.walletId = kDefaultWalletId,
  });

  final int amount;
  final String type;
  final String? categoryId;
  final String note;
  final DateTime happenedAt;
  final String walletId;

  TransactionsCompanion toCompanion() {
    final String nowIsoUtc = DateTime.now().toUtc().toIso8601String();
    return TransactionsCompanion.insert(
      id: 'tx_${DateTime.now().microsecondsSinceEpoch}',
      type: type,
      walletId: walletId,
      categoryId: Value<String?>(categoryId),
      amount: amount,
      feeAmount: const Value<int>(0),
      currencyCode: const Value<String>('VND'),
      happenedAt: happenedAt.toUtc().toIso8601String(),
      note: Value<String?>(note.isEmpty ? null : note),
      status: const Value<String>(kTransactionStatusPosted),
      createdAt: nowIsoUtc,
      updatedAt: nowIsoUtc,
    );
  }
}
