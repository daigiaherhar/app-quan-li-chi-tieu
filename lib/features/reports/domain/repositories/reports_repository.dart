import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/reports/domain/entities/reports_entity.dart';

abstract class ReportsRepository {
  Future<Result<ReportsEntity>> getReports();
}
