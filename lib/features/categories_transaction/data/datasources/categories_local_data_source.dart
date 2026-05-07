import 'package:drift/drift.dart' show OrderingMode, OrderingTerm;
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/data/models/category_model.dart';

abstract class CategoriesLocalDataSource {
  Stream<List<CategoryModel>> watchActiveByKind(String? kind);
}

class CategoriesLocalDataSourceImpl implements CategoriesLocalDataSource {
  CategoriesLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<CategoryModel>> watchActiveByKind(String? kind) {
    final query = _database.select(_database.categoriesTransaction)
      ..where((table) => table.deletedAt.isNull())
      ..where((table) => table.isActive.equals(1));
    if (kind != null) {
      query.where((table) => table.kind.equals(kind));
    }
    query.orderBy([
      (table) => OrderingTerm(
        expression: table.displayOrder,
        mode: OrderingMode.asc,
      ),
      (table) => OrderingTerm(expression: table.name, mode: OrderingMode.asc),
    ]);
    return query.watch().map(
      (List<CategoryTransaction> rows) =>
          rows.map(CategoryModel.fromDrift).toList(),
    );
  }
}
