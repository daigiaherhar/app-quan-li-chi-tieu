class ReportsEntity {
  const ReportsEntity({
    required this.id,
  });

  final String id;

  ReportsEntity copyWith({
    String? id,
  }) {
    return ReportsEntity(
      id: id ?? this.id,
    );
  }
}
