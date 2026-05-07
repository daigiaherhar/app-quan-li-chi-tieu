import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/repositories/wallets_repository.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/usecases/delete_wallet_params.dart';

class DeleteWalletUseCase extends BaseUseCase<DeleteWalletParams, void> {
  DeleteWalletUseCase(this._repository);

  final WalletsRepository _repository;

  @override
  Future<Result<void>> call(DeleteWalletParams params) {
    return _repository.deleteWallet(params);
  }
}
