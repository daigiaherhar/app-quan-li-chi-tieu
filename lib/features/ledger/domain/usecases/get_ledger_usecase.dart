import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/ledger/domain/entities/ledger_entity.dart';
import 'package:quan_ly_chi_tieu/features/ledger/domain/repositories/ledger_repository.dart';

class GetLedgerUseCase extends BaseUseCaseNoParams<LedgerEntity> {
  GetLedgerUseCase(
    this._repository,
  );

  final LedgerRepository _repository;

  @override
  Future<Result<LedgerEntity>> call() async {
    return _repository.getLedger();
  }
}
