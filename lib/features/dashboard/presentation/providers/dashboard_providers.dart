import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/core/database/database_providers.dart';
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/presentation/models/transaction_category_entity.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/presentation/providers/categories_providers.dart';

final StreamProvider<double> dashboardWalletTotalProvider =
    StreamProvider<double>((Ref ref) {
      final AppDatabase database = ref.watch(appDatabaseProvider);
      final query = database.select(database.wallets)
        ..where((table) => table.deletedAt.isNull())
        ..where((table) => table.isActive.equals(1));
      return query.watch().map((List<Wallet> rows) {
        return rows.fold<double>(
          0,
          (double total, Wallet wallet) =>
              total + wallet.currentBalance.toDouble(),
        );
      });
    });

final StreamProvider<List<TransactionEntity>> dashboardTransactionsProvider =
    StreamProvider<List<TransactionEntity>>((Ref ref) {
      final AppDatabase database = ref.watch(appDatabaseProvider);

      final List<TransactionCategoryEntity> categoriesTransaction = ref
          .watch(transactionCategoryOptionsProvider(null))
          .requireValue;

      final query = database.select(database.transactions)
        ..where((table) => table.deletedAt.isNull());
      return query.watch().map((List<Transaction> rows) {
        final List<TransactionEntity> items = rows
            .map(
              (row) => _mapTransactionRowToEntity(
                row: row,
                listCategory: categoriesTransaction,
              ),
            )
            .toList();
        items.sort(
          (TransactionEntity a, TransactionEntity b) =>
              b.happenedAt.compareTo(a.happenedAt),
        );
        return items;
      });
    });

TransactionEntity _mapTransactionRowToEntity({
  required Transaction row,
  List<TransactionCategoryEntity> listCategory = const [],
}) {
  final DateTime happenedAt =
      DateTime.tryParse(row.happenedAt) ?? DateTime.now();
  final TransactionType type = switch (row.type) {
    kTransactionTypeIncome => TransactionType.income,
    kTransactionTypeExpense => TransactionType.expense,
    _ => TransactionType.transfer,
  };
  final String nameCategory = listCategory
      .firstWhere((element) => element.id == row.categoryId)
      .label;
  return TransactionEntity(
    id: row.id,
    type: type,
    amount: row.amount.toDouble(),
    happenedAt: happenedAt,
    note: row.note,
    categoryId: row.categoryId,
    walletId: row.walletId,
    nameCategory: nameCategory,
  );
}
