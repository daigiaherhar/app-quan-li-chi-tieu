import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/database/database_providers.dart';
import 'package:quan_ly_chi_tieu/core/models/transaction_wallet_entity.dart';
import 'package:quan_ly_chi_tieu/features/transactions/data/datasources/transactions_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:quan_ly_chi_tieu/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:quan_ly_chi_tieu/features/transactions/domain/usecases/save_transaction_usecase.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transaction_notifier.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transaction_state.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/entities/wallet_entity.dart';
import 'package:quan_ly_chi_tieu/features/wallets/presentation/providers/wallets_providers.dart';

final Provider<TransactionsLocalDataSource>
transactionsLocalDataSourceProvider = Provider<TransactionsLocalDataSource>((
  Ref ref,
) {
  return TransactionsLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

final Provider<TransactionsRepository> transactionsRepositoryProvider =
    Provider<TransactionsRepository>((Ref ref) {
      return TransactionsRepositoryImpl(
        ref.watch(transactionsLocalDataSourceProvider),
      );
    });

final Provider<SaveTransactionUseCase> saveTransactionUseCaseProvider =
    Provider<SaveTransactionUseCase>((Ref ref) {
      return SaveTransactionUseCase(ref.watch(transactionsRepositoryProvider));
    });

/// Wallet picker options for the transaction form.
///
/// Reuses the wallets feature's read use-case so the transactions feature does
/// not duplicate the wallet query and stays free of any Drift dependency.
final StreamProvider<List<TransactionWalletEntity>>
transactionWalletOptionsProvider =
    StreamProvider<List<TransactionWalletEntity>>((Ref ref) {
      return ref.watch(watchActiveWalletsUseCaseProvider).call().map((
        List<WalletEntity> wallets,
      ) {
        final List<TransactionWalletEntity> mapped = wallets
            .map(
              (WalletEntity wallet) =>
                  TransactionWalletEntity(id: wallet.id, name: wallet.name),
            )
            .toList();

        return mapped;
      });
    });

final transactionProvider = NotifierProvider.autoDispose
    .family<TransactionNotifier, TransactionState, TransactionFlowKind>(
      TransactionNotifier.new,
    );
