import 'package:drift/drift.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfile> getProfile();

  Future<bool> hasUserInfo();

  Future<UserProfile> saveUserInfoStatus({
    required bool hasUserInfo,
    String? displayName,
  });
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl(this._database);

  static const int _profileId = 1;

  final AppDatabase _database;

  @override
  Future<UserProfile> getProfile() async {
    final UserProfile? profile = await (_database.select(
      _database.userProfiles,
    )..where((table) => table.id.equals(_profileId))).getSingleOrNull();
    if (profile != null) {
      return profile;
    }
    return saveUserInfoStatus(hasUserInfo: false);
  }

  @override
  Future<bool> hasUserInfo() async {
    final UserProfile profile = await getProfile();
    return profile.hasUserInfo;
  }

  @override
  Future<UserProfile> saveUserInfoStatus({
    required bool hasUserInfo,
    String? displayName,
  }) async {
    final UserProfilesCompanion companion = UserProfilesCompanion(
      id: const Value<int>(_profileId),
      displayName: Value<String?>(displayName),
      hasUserInfo: Value<bool>(hasUserInfo),
      updatedAt: Value<DateTime>(DateTime.now()),
    );
    await _database
        .into(_database.userProfiles)
        .insertOnConflictUpdate(companion);
    return getProfile();
  }
}
