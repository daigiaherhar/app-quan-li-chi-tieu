import 'package:drift/drift.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/features/transactions/data/models/transaction_model.dart';

abstract class TransactionsLocalDataSource {
  Future<void> saveTransaction(TransactionModel model);
}

class TransactionsLocalDataSourceImpl implements TransactionsLocalDataSource {
  TransactionsLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<void> saveTransaction(TransactionModel model) async {
    await _database.transaction(() async {
      await _database.into(_database.transactions).insert(model.toCompanion());
      await _applyWalletBalanceChange(model);
    });
  }

  /// Atomic balance update — kept inside the same Drift transaction so a failed
  /// wallet update rolls back the inserted transaction row.
  Future<void> _applyWalletBalanceChange(TransactionModel model) async {
    final int deltaAmount = switch (model.type) {
      kTransactionTypeIncome => model.amount,
      kTransactionTypeExpense => -model.amount,
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
        Variable<String>(model.walletId),
      ],
      updates: <ResultSetImplementation<dynamic, dynamic>>{_database.wallets},
    );
  }
}
