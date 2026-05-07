import 'package:quan_ly_chi_tieu/features/wallets/domain/entities/wallet_entity.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/repositories/wallets_repository.dart';

/// Streams the list of active wallets.
///
/// Returns a [Stream] (not [Future]<[Result]>) because the source is reactive —
/// errors are surfaced via the stream's error channel and handled in the UI's
/// `AsyncValue.error` branch.
class WatchActiveWalletsUseCase {
  WatchActiveWalletsUseCase(this._repository);

  final WalletsRepository _repository;

  Stream<List<WalletEntity>> call() {
    return _repository.watchActiveWallets();
  }
}
