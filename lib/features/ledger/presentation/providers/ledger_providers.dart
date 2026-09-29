import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/database/database_providers.dart';
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';
import 'package:quan_ly_chi_tieu/features/ledger/data/datasources/ledger_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/ledger/data/repositories/ledger_repository_impl.dart';
import 'package:quan_ly_chi_tieu/features/ledger/domain/repositories/ledger_repository.dart';
import 'package:quan_ly_chi_tieu/features/ledger/domain/usecases/watch_ledger_transactions_usecase.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_notifier.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_state.dart';

final Provider<LedgerLocalDataSource> ledgerLocalDataSourceProvider =
    Provider<LedgerLocalDataSource>((Ref ref) {
      return LedgerLocalDataSourceImpl(ref.watch(appDatabaseProvider));
    });

final Provider<LedgerRepository> ledgerRepositoryProvider =
    Provider<LedgerRepository>((Ref ref) {
      return LedgerRepositoryImpl(ref.watch(ledgerLocalDataSourceProvider));
    });

final Provider<WatchLedgerTransactionsUseCase>
watchLedgerTransactionsUseCaseProvider =
    Provider<WatchLedgerTransactionsUseCase>((Ref ref) {
      return WatchLedgerTransactionsUseCase(
        ref.watch(ledgerRepositoryProvider),
      );
    });

final StreamProvider<List<TransactionEntity>> ledgerTransactionsProvider =
    StreamProvider<List<TransactionEntity>>((Ref ref) {
      return ref.watch(watchLedgerTransactionsUseCaseProvider).call();
    });

final NotifierProvider<LedgerNotifier, LedgerState> ledgerProvider =
    NotifierProvider<LedgerNotifier, LedgerState>(LedgerNotifier.new);
