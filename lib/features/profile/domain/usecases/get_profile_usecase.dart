import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/entities/profile_entity.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase extends BaseUseCaseNoParams<ProfileEntity> {
  GetProfileUseCase(
    this._repository,
  );

  final ProfileRepository _repository;

  @override
  Future<Result<ProfileEntity>> call() async {
    return _repository.getProfile();
  }
}
