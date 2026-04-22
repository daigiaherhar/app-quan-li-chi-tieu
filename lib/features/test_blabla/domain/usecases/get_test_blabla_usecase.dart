import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/test_blabla/domain/entities/test_blabla_entity.dart';
import 'package:quan_ly_chi_tieu/features/test_blabla/domain/repositories/test_blabla_repository.dart';

class GetTestBlablaUseCase extends BaseUseCaseNoParams<TestBlablaEntity> {
  GetTestBlablaUseCase(
    this._repository,
  );

  final TestBlablaRepository _repository;

  @override
  Future<Result<TestBlablaEntity>> call() async {
    return _repository.getTestBlabla();
  }
}
