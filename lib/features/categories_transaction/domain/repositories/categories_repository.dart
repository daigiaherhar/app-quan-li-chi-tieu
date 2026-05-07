import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/entities/category_entity.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/usecases/watch_categories_by_kind_params.dart';

abstract class CategoriesRepository {
  Stream<List<CategoryEntity>> watchActiveByKind(
    WatchCategoriesByKindParams params,
  );
}
