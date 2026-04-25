class DashboardEntity {
  const DashboardEntity({
    required this.id,
  });

  final String id;

  DashboardEntity copyWith({
    String? id,
  }) {
    return DashboardEntity(
      id: id ?? this.id,
    );
  }
}
