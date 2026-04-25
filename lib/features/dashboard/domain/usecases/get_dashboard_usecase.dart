import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:quan_ly_chi_tieu/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardUseCase extends BaseUseCaseNoParams<DashboardEntity> {
  GetDashboardUseCase(
    this._repository,
  );

  final DashboardRepository _repository;

  @override
  Future<Result<DashboardEntity>> call() async {
    return _repository.getDashboard();
  }
}
