import 'package:quan_ly_chi_tieu/features/categories_transaction/data/datasources/categories_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/data/models/category_model.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/entities/category_entity.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/repositories/categories_repository.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/usecases/watch_categories_by_kind_params.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  CategoriesRepositoryImpl(this._localDataSource);

  final CategoriesLocalDataSource _localDataSource;

  @override
  Stream<List<CategoryEntity>> watchActiveByKind(
    WatchCategoriesByKindParams params,
  ) {
    return _localDataSource
        .watchActiveByKind(params.kind)
        .map(
          (List<CategoryModel> models) =>
              models.map((CategoryModel model) => model.toEntity()).toList(),
        );
  }
}
