import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/wallets/data/datasources/wallets_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/wallets/data/models/wallet_model.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/entities/wallet_entity.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/repositories/wallets_repository.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/usecases/create_wallet_params.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/usecases/delete_wallet_params.dart';

class WalletsRepositoryImpl implements WalletsRepository {
  WalletsRepositoryImpl(this._localDataSource);

  final WalletsLocalDataSource _localDataSource;

  @override
  Stream<List<WalletEntity>> watchActiveWallets() {
    return _localDataSource.watchActiveWallets().map(
          (List<WalletModel> models) => models
              .map((WalletModel model) => model.toEntity())
              .toList(growable: false),
        );
  }

  @override
  Future<Result<void>> createWallet(CreateWalletParams params) async {
    try {
      await _localDataSource.createWallet(
        WalletModel(
          name: params.name,
          type: params.type,
          openingBalance: params.openingBalance,
        ),
      );
      return const Success<void>(null);
    } catch (error) {
      return Failure<void>(error.toString());
    }
  }

  @override
  Future<Result<void>> deleteWallet(DeleteWalletParams params) async {
    try {
      await _localDataSource.softDeleteWallet(params.id);
      return const Success<void>(null);
    } catch (error) {
      return Failure<void>(error.toString());
    }
  }
}
