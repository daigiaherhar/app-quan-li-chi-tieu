import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/repositories/wallets_repository.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/usecases/create_wallet_params.dart';

class CreateWalletUseCase extends BaseUseCase<CreateWalletParams, void> {
  CreateWalletUseCase(this._repository);

  final WalletsRepository _repository;

  @override
  Future<Result<void>> call(CreateWalletParams params) {
    return _repository.createWallet(params);
  }
}
