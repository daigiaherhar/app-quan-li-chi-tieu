import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/features/wallets/data/models/wallet_model.dart';

abstract class WalletsLocalDataSource {
  Stream<List<WalletModel>> watchActiveWallets();
  Future<void> createWallet(WalletModel model);
}

class WalletsLocalDataSourceImpl implements WalletsLocalDataSource {
  WalletsLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<WalletModel>> watchActiveWallets() {
    final query = _database.select(_database.wallets)
      ..where((table) => table.deletedAt.isNull())
      ..where((table) => table.isActive.equals(1));
    return query.watch().map((List<Wallet> rows) {
      final List<Wallet> sorted = List<Wallet>.from(rows);
      sorted.sort((Wallet a, Wallet b) {
        final int orderCompare = a.displayOrder.compareTo(b.displayOrder);
        if (orderCompare != 0) {
          return orderCompare;
        }
        return a.name.compareTo(b.name);
      });
      return sorted
          .map((Wallet row) => WalletModel.fromDrift(row))
          .toList(growable: false);
    });
  }

  @override
  Future<void> createWallet(WalletModel model) async {
    await _database.into(_database.wallets).insert(model.toCompanion());
  }
}
