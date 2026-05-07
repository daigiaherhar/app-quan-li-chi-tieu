import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/profile/data/models/profile_model.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/entities/profile_entity.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._localDataSource);

  final ProfileLocalDataSource _localDataSource;

  @override
  Future<Result<ProfileEntity>> getProfile() async {
    try {
      final UserProfile profile = await _localDataSource.getProfile();
      return Success<ProfileEntity>(ProfileModel.fromDatabase(profile));
    } catch (error) {
      return Failure<ProfileEntity>(error.toString());
    }
  }

  @override
  Future<Result<bool>> hasUserInfo() async {
    try {
      final bool hasUserInfo = await _localDataSource.hasUserInfo();
      return Success<bool>(hasUserInfo);
    } catch (error) {
      return Failure<bool>(error.toString());
    }
  }

  @override
  Future<Result<ProfileEntity>> saveUserInfoStatus({
    required bool hasUserInfo,
    String? displayName,
  }) async {
    try {
      final UserProfile profile = await _localDataSource.saveUserInfoStatus(
        hasUserInfo: hasUserInfo,
        displayName: displayName,
      );
      return Success<ProfileEntity>(ProfileModel.fromDatabase(profile));
    } catch (error) {
      return Failure<ProfileEntity>(error.toString());
    }
  }
}
