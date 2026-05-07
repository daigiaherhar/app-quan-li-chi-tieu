import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/core/database/database_providers.dart';
import 'package:quan_ly_chi_tieu/core/models/transaction_wallet_entity.dart';
import 'package:quan_ly_chi_tieu/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transaction_state.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transaction_notifier.dart';

final Provider<TransactionLocalDataSource> transactionLocalDataSourceProvider =
    Provider<TransactionLocalDataSource>((Ref ref) {
  return TransactionLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

final StreamProvider<List<TransactionWalletEntity>>
    transactionWalletOptionsProvider =
    StreamProvider<List<TransactionWalletEntity>>((Ref ref) {
      final AppDatabase database = ref.watch(appDatabaseProvider);
      final query = database.select(database.wallets)
        ..where((table) => table.deletedAt.isNull())
        ..where((table) => table.isActive.equals(1));
      return query.watch().map((List<Wallet> rows) {
        final List<TransactionWalletEntity> wallets = rows
            .map(
              (Wallet wallet) =>
                  TransactionWalletEntity(id: wallet.id, name: wallet.name),
            )
            .toList();
        wallets.sort((a, b) => a.name.compareTo(b.name));
        return wallets;
      });
    });

final transactionProvider = NotifierProvider.autoDispose.family<
    TransactionNotifier,
    TransactionState,
    TransactionFlowKind>(TransactionNotifier.new);
