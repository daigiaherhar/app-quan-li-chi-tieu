import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/ledger/domain/entities/ledger_entity.dart';

abstract class LedgerRepository {
  Future<Result<LedgerEntity>> getLedger();
}
