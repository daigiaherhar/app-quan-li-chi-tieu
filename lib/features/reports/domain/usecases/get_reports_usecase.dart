import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/reports/domain/entities/reports_entity.dart';
import 'package:quan_ly_chi_tieu/features/reports/domain/repositories/reports_repository.dart';

class GetReportsUseCase extends BaseUseCaseNoParams<ReportsEntity> {
  GetReportsUseCase(
    this._repository,
  );

  final ReportsRepository _repository;

  @override
  Future<Result<ReportsEntity>> call() async {
    return _repository.getReports();
  }
}
