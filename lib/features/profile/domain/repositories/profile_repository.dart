import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Result<ProfileEntity>> getProfile();

  Future<Result<bool>> hasUserInfo();

  Future<Result<ProfileEntity>> saveUserInfoStatus({
    required bool hasUserInfo,
    String? displayName,
  });
}
