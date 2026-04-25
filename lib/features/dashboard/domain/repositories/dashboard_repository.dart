import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/dashboard/domain/entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<Result<DashboardEntity>> getDashboard();
}
