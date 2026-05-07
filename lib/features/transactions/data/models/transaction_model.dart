import 'package:drift/drift.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';

/// Data-layer model mirroring the transactions row schema.
///
/// Used as the write shape for inserting a transaction:
/// - For new transactions: leave [id] null — [toCompanion] will generate one.
/// - Read flows for transactions live in the `ledger` feature; this feature is
///   write-only, so no `fromDrift` / `toEntity` is provided here yet.
class TransactionModel {
  const TransactionModel({
    this.id,
    required this.amount,
    required this.type,
    required this.walletId,
    required this.note,
    required this.happenedAt,
    this.categoryId,
  });

  final String? id;
  final int amount;
  final String type;
  final String walletId;
  final String note;
  final DateTime happenedAt;
  final String? categoryId;

  TransactionsCompanion toCompanion() {
    final String nowIsoUtc = DateTime.now().toUtc().toIso8601String();
    final String resolvedId =
        id ?? 'tx_${DateTime.now().microsecondsSinceEpoch}';
    return TransactionsCompanion.insert(
      id: resolvedId,
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
