import 'package:quan_ly_chi_tieu/features/reports/domain/entities/reports_summary_entity.dart';

abstract class ReportsRepository {
  Stream<ReportsSummaryEntity> watchSummary();
}
