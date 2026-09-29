import 'package:drift/drift.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/features/ledger/data/models/ledger_transaction_model.dart';

abstract class LedgerLocalDataSource {
  Stream<List<LedgerTransactionModel>> watchTransactions();
}

class LedgerLocalDataSourceImpl implements LedgerLocalDataSource {
  LedgerLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<LedgerTransactionModel>> watchTransactions() {
    final query = _database.select(_database.transactions).join([
      leftOuterJoin(
        _database.categoriesTransaction,
        _database.categoriesTransaction.id.equalsExp(
          _database.transactions.categoryId,
        ),
      ),
    ])
      ..where(_database.transactions.deletedAt.isNull())
      ..where(
        _database.transactions.type.isIn(<String>[
          kTransactionTypeIncome,
          kTransactionTypeExpense,
        ]),
      )
      ..orderBy(<OrderingTerm>[
        OrderingTerm(
          expression: _database.transactions.happenedAt,
          mode: OrderingMode.desc,
        ),
      ]);

    return query.watch().map((List<TypedResult> rows) {
      return rows
          .map((TypedResult row) {
            final Transaction transaction = row.readTable(
              _database.transactions,
            );
            final CategoryTransaction? category = row.readTableOrNull(
              _database.categoriesTransaction,
            );
            return LedgerTransactionModel.fromDrift(
              transaction,
              categoryName: category?.name,
            );
          })
          .toList(growable: false);
    });
  }
}
