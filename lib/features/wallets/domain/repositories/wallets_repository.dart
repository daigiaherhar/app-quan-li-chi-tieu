import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/entities/wallet_entity.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/usecases/create_wallet_params.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/usecases/delete_wallet_params.dart';

abstract class WalletsRepository {
  Stream<List<WalletEntity>> watchActiveWallets();

  Future<Result<void>> createWallet(CreateWalletParams params);

  Future<Result<void>> deleteWallet(DeleteWalletParams params);
}
