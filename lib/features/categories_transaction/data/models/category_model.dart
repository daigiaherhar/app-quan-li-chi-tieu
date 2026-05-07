import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/entities/category_entity.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.kind,
    required this.iconKey,
    required this.isSystem,
    required this.displayOrder,
  });

  factory CategoryModel.fromDrift(CategoryTransaction row) {
    return CategoryModel(
      id: row.id,
      name: row.name,
      kind: row.kind,
      iconKey: row.iconKey,
      isSystem: row.isSystem == 1,
      displayOrder: row.displayOrder,
    );
  }

  final String id;
  final String name;
  final String kind;
  final String? iconKey;
  final bool isSystem;
  final int displayOrder;
}

extension CategoryModelToEntity on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      kind: kind,
      iconKey: iconKey,
      isSystem: isSystem,
      displayOrder: displayOrder,
    );
  }
}
