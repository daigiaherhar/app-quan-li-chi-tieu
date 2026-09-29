import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';
import 'package:quan_ly_chi_tieu/features/ledger/domain/repositories/ledger_repository.dart';

/// Streams ledger transactions (income + expense, not soft-deleted).
class WatchLedgerTransactionsUseCase
    extends BaseStreamUseCaseNoParams<List<TransactionEntity>> {
  WatchLedgerTransactionsUseCase(this._repository);

  final LedgerRepository _repository;

  @override
  Stream<List<TransactionEntity>> call() {
    return _repository.watchTransactions();
  }
}
