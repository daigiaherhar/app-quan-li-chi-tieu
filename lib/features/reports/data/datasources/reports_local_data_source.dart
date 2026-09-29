import 'package:drift/drift.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/features/reports/data/models/reports_transaction_model.dart';

abstract class ReportsLocalDataSource {
  Stream<List<ReportsTransactionModel>> watchTransactions();
}

class ReportsLocalDataSourceImpl implements ReportsLocalDataSource {
  ReportsLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<ReportsTransactionModel>> watchTransactions() {
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
            return ReportsTransactionModel.fromDrift(
              transaction,
              category: category,
            );
          })
          .toList(growable: false);
    });
  }
}
