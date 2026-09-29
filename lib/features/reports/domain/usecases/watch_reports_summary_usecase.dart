import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/features/reports/domain/entities/reports_summary_entity.dart';
import 'package:quan_ly_chi_tieu/features/reports/domain/repositories/reports_repository.dart';

class WatchReportsSummaryUseCase
    extends BaseStreamUseCaseNoParams<ReportsSummaryEntity> {
  WatchReportsSummaryUseCase(this._repository);

  final ReportsRepository _repository;

  @override
  Stream<ReportsSummaryEntity> call() {
    return _repository.watchSummary();
  }
}
