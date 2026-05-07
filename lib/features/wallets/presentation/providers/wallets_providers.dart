import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/database/database_providers.dart';
import 'package:quan_ly_chi_tieu/features/wallets/data/datasources/wallets_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/wallets/data/repositories/wallets_repository_impl.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/entities/wallet_entity.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/repositories/wallets_repository.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/usecases/create_wallet_usecase.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/usecases/watch_active_wallets_usecase.dart';
import 'package:quan_ly_chi_tieu/features/wallets/presentation/providers/add_wallet_notifier.dart';
import 'package:quan_ly_chi_tieu/features/wallets/presentation/providers/add_wallet_state.dart';

final Provider<WalletsLocalDataSource> walletsLocalDataSourceProvider =
    Provider<WalletsLocalDataSource>((Ref ref) {
  return WalletsLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

final Provider<WalletsRepository> walletsRepositoryProvider =
    Provider<WalletsRepository>((Ref ref) {
  return WalletsRepositoryImpl(ref.watch(walletsLocalDataSourceProvider));
});

final Provider<WatchActiveWalletsUseCase> watchActiveWalletsUseCaseProvider =
    Provider<WatchActiveWalletsUseCase>((Ref ref) {
  return WatchActiveWalletsUseCase(ref.watch(walletsRepositoryProvider));
});

final Provider<CreateWalletUseCase> createWalletUseCaseProvider =
    Provider<CreateWalletUseCase>((Ref ref) {
  return CreateWalletUseCase(ref.watch(walletsRepositoryProvider));
});

final StreamProvider<List<WalletEntity>> walletsProvider =
    StreamProvider<List<WalletEntity>>((Ref ref) {
  return ref.watch(watchActiveWalletsUseCaseProvider).call();
});

final NotifierProvider<AddWalletNotifier, AddWalletState> addWalletProvider =
    NotifierProvider<AddWalletNotifier, AddWalletState>(AddWalletNotifier.new);
