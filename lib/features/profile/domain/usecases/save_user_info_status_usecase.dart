import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/entities/profile_entity.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/repositories/profile_repository.dart';

class SaveUserInfoStatusParams {
  const SaveUserInfoStatusParams({required this.hasUserInfo, this.displayName});

  final bool hasUserInfo;
  final String? displayName;
}

class SaveUserInfoStatusUseCase
    extends BaseUseCase<SaveUserInfoStatusParams, ProfileEntity> {
  SaveUserInfoStatusUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Result<ProfileEntity>> call(SaveUserInfoStatusParams params) {
    return _repository.saveUserInfoStatus(
      hasUserInfo: params.hasUserInfo,
      displayName: params.displayName,
    );
  }
}
