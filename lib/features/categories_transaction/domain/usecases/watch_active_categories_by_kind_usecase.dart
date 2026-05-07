import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/entities/category_entity.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/repositories/categories_repository.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/usecases/watch_categories_by_kind_params.dart';

class WatchActiveCategoriesByKindUseCase
    extends
        BaseStreamUseCase<WatchCategoriesByKindParams, List<CategoryEntity>> {
  WatchActiveCategoriesByKindUseCase(this._repository);

  final CategoriesRepository _repository;

  @override
  Stream<List<CategoryEntity>> call(WatchCategoriesByKindParams params) {
    return _repository.watchActiveByKind(params);
  }
}
