import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/repositories/profile_repository.dart';

class HasUserInfoUseCase extends BaseUseCaseNoParams<bool> {
  HasUserInfoUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Result<bool>> call() {
    return _repository.hasUserInfo();
  }
}
