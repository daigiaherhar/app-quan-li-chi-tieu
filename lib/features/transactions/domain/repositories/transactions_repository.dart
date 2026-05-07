import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/transactions/domain/usecases/save_transaction_params.dart';

abstract class TransactionsRepository {
  Future<Result<void>> saveTransaction(SaveTransactionParams params);
}
