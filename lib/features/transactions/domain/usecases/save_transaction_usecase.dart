import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:quan_ly_chi_tieu/features/transactions/domain/usecases/save_transaction_params.dart';

class SaveTransactionUseCase extends BaseUseCase<SaveTransactionParams, void> {
  SaveTransactionUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Result<void>> call(SaveTransactionParams params) {
    return _repository.saveTransaction(params);
  }
}
