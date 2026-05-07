import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.hasUserInfo,
    super.displayName,
  });

  factory ProfileModel.fromDatabase(UserProfile profile) {
    return ProfileModel(
      id: profile.id.toString(),
      hasUserInfo: profile.hasUserInfo,
      displayName: profile.displayName,
    );
  }
}
