class ProfileEntity {
  const ProfileEntity({
    required this.id,
  });

  final String id;

  ProfileEntity copyWith({
    String? id,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
    );
  }
}
