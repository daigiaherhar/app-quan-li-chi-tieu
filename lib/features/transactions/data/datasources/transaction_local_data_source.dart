import 'package:drift/drift.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/features/transactions/data/models/transaction_dto.dart';

abstract class TransactionLocalDataSource {
  Future<int> saveTransaction(TransactionDto transaction);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  TransactionLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<int> saveTransaction(TransactionDto transaction) async {
    return _database.transaction(() async {
      final int insertedRowId = await _database
          .into(_database.transactions)
          .insert(transaction.toCompanion());
      await _applyWalletBalanceChange(transaction);
      return insertedRowId;
    });
  }

  Future<void> _applyWalletBalanceChange(TransactionDto transaction) async {
    final int deltaAmount = switch (transaction.type) {
      kTransactionTypeIncome => transaction.amount,
      kTransactionTypeExpense => -transaction.amount,
      _ => 0,
    };
    if (deltaAmount == 0) {
      return;
    }
    final String nowIsoUtc = DateTime.now().toUtc().toIso8601String();
    await _database.customUpdate(
      '''
UPDATE wallets
SET current_balance = current_balance + ?, updated_at = ?
WHERE id = ? AND deleted_at IS NULL AND is_active = 1
''',
      variables: <Variable<Object>>[
        Variable<int>(deltaAmount),
        Variable<String>(nowIsoUtc),
        Variable<String>(transaction.walletId),
      ],
      updates: <ResultSetImplementation<dynamic, dynamic>>{_database.wallets},
    );
  }
}
