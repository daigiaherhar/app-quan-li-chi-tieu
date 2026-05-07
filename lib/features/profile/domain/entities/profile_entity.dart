class ProfileEntity {
  const ProfileEntity({
    required this.id,
    required this.hasUserInfo,
    this.displayName,
  });

  final String id;
  final bool hasUserInfo;
  final String? displayName;

  ProfileEntity copyWith({String? id, bool? hasUserInfo, String? displayName}) {
    return ProfileEntity(
      id: id ?? this.id,
      hasUserInfo: hasUserInfo ?? this.hasUserInfo,
      displayName: displayName ?? this.displayName,
    );
  }
}
