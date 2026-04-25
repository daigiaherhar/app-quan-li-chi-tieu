class LedgerEntity {
  const LedgerEntity({
    required this.id,
  });

  final String id;

  LedgerEntity copyWith({
    String? id,
  }) {
    return LedgerEntity(
      id: id ?? this.id,
    );
  }
}
