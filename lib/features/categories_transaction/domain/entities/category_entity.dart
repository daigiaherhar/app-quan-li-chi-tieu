class CategoryEntity {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.kind,
    required this.iconKey,
    required this.isSystem,
    required this.displayOrder,
  });

  final String id;
  final String name;
  final String kind;
  final String? iconKey;
  final bool isSystem;
  final int displayOrder;
}
