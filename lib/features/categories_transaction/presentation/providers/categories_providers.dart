import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/database/database_providers.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/presentation/models/transaction_category_entity.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/data/datasources/categories_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/data/repositories/categories_repository_impl.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/entities/category_entity.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/repositories/categories_repository.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/usecases/watch_active_categories_by_kind_usecase.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/domain/usecases/watch_categories_by_kind_params.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/presentation/utils/category_icon_for_key.dart';

final Provider<CategoriesLocalDataSource> categoriesLocalDataSourceProvider =
    Provider<CategoriesLocalDataSource>((Ref ref) {
      return CategoriesLocalDataSourceImpl(ref.watch(appDatabaseProvider));
    });

final Provider<CategoriesRepository> categoriesRepositoryProvider =
    Provider<CategoriesRepository>((Ref ref) {
      return CategoriesRepositoryImpl(
        ref.watch(categoriesLocalDataSourceProvider),
      );
    });

final Provider<WatchActiveCategoriesByKindUseCase>
watchActiveCategoriesByKindUseCaseProvider =
    Provider<WatchActiveCategoriesByKindUseCase>((Ref ref) {
      return WatchActiveCategoriesByKindUseCase(
        ref.watch(categoriesRepositoryProvider),
      );
    });

/// Stream of selectable categories for the transaction form, scoped by [kind]
/// (`income` or `expense`). Maps the data-layer entity to the picker-friendly
/// [TransactionCategoryEntity] (label + icon).
final transactionCategoryOptionsProvider =
    StreamProvider.family<List<TransactionCategoryEntity>, String?>((
      Ref ref,
      String? kind,
    ) {
      return ref
          .watch(watchActiveCategoriesByKindUseCaseProvider)
          .call(WatchCategoriesByKindParams(kind: kind))
          .map(
            (List<CategoryEntity> categories) => categories
                .map(
                  (CategoryEntity category) => TransactionCategoryEntity(
                    id: category.id,
                    label: category.name,
                    icon: categoryIconForKey(category.iconKey),
                  ),
                )
                .toList(),
          );
    });
