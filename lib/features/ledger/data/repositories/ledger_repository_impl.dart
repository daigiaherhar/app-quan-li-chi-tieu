import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';
import 'package:quan_ly_chi_tieu/features/ledger/data/datasources/ledger_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/ledger/data/models/ledger_transaction_model.dart';
import 'package:quan_ly_chi_tieu/features/ledger/domain/repositories/ledger_repository.dart';

class LedgerRepositoryImpl implements LedgerRepository {
  LedgerRepositoryImpl(this._localDataSource);

  final LedgerLocalDataSource _localDataSource;

  @override
  Stream<List<TransactionEntity>> watchTransactions() {
    return _localDataSource.watchTransactions().map(
      (List<LedgerTransactionModel> models) => models
          .map((LedgerTransactionModel model) => model.toEntity())
          .toList(growable: false),
    );
  }
}
