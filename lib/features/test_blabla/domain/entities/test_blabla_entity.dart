class TestBlablaEntity {
  const TestBlablaEntity({
    required this.id,
  });

  final String id;

  TestBlablaEntity copyWith({
    String? id,
  }) {
    return TestBlablaEntity(
      id: id ?? this.id,
    );
  }
}
