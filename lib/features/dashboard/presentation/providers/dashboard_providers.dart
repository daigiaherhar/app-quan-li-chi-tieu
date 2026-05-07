import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/core/database/database_providers.dart';
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';

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
      final query = database.select(database.transactions)
        ..where((table) => table.deletedAt.isNull());
      return query.watch().map(
        (List<Transaction> rows) {
          final List<TransactionEntity> items = rows
              .map(_mapTransactionRowToEntity)
              .toList();
          items.sort(
            (TransactionEntity a, TransactionEntity b) =>
                b.happenedAt.compareTo(a.happenedAt),
          );
          return items;
        },
      );
    });

TransactionEntity _mapTransactionRowToEntity(Transaction row) {
  final DateTime happenedAt = DateTime.tryParse(row.happenedAt) ?? DateTime.now();
  final TransactionType type = switch (row.type) {
    kTransactionTypeIncome => TransactionType.income,
    kTransactionTypeExpense => TransactionType.expense,
    _ => TransactionType.transfer,
  };
  return TransactionEntity(
    id: row.id,
    type: type,
    amount: row.amount.toDouble(),
    happenedAt: happenedAt,
    note: row.note,
    categoryId: row.categoryId,
    walletId: row.walletId,
  );
}
