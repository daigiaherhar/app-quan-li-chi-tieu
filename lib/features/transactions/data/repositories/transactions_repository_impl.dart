import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/transactions/data/datasources/transactions_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/transactions/data/models/transaction_model.dart';
import 'package:quan_ly_chi_tieu/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:quan_ly_chi_tieu/features/transactions/domain/usecases/save_transaction_params.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  TransactionsRepositoryImpl(this._localDataSource);

  final TransactionsLocalDataSource _localDataSource;

  @override
  Future<Result<void>> saveTransaction(SaveTransactionParams params) async {
    try {
      await _localDataSource.saveTransaction(
        TransactionModel(
          amount: params.amount,
          type: params.type,
          walletId: params.walletId,
          note: params.note,
          happenedAt: params.happenedAt,
          categoryId: params.categoryId,
        ),
      );
      return const Success<void>(null);
    } catch (error) {
      return Failure<void>(error.toString());
    }
  }
}
