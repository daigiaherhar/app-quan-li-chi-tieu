import 'package:drift/drift.dart' show OrderingMode, OrderingTerm, Value;
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/features/wallets/data/models/wallet_model.dart';

abstract class WalletsLocalDataSource {
  Stream<List<WalletModel>> watchActiveWallets();
  Future<void> createWallet(WalletModel model);

  /// Soft-deletes the wallet by setting [Wallet.deletedAt] to now.
  Future<void> softDeleteWallet(String walletId);
}

class WalletsLocalDataSourceImpl implements WalletsLocalDataSource {
  WalletsLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<WalletModel>> watchActiveWallets() {
    final query = _database.select(_database.wallets)
      ..where((table) => table.deletedAt.isNull())
      ..where((table) => table.isActive.equals(1))
      ..orderBy([
        (table) => OrderingTerm(
              expression: table.isDefault,
              mode: OrderingMode.desc,
            ),
        (table) => OrderingTerm(
              expression: table.createdAt,
              mode: OrderingMode.desc,
            ),
      ]);
    return query.watch().map(
          (List<Wallet> rows) => rows
              .map((Wallet row) => WalletModel.fromDrift(row))
              .toList(growable: false),
        );
  }

  @override
  Future<void> createWallet(WalletModel model) async {
    await _database.into(_database.wallets).insert(model.toCompanion());
  }

  @override
  Future<void> softDeleteWallet(String walletId) async {
    final String nowIsoUtc = DateTime.now().toUtc().toIso8601String();
    await (_database.update(_database.wallets)
          ..where((table) => table.id.equals(walletId)))
        .write(
      WalletsCompanion(
        deletedAt: Value<String?>(nowIsoUtc),
        updatedAt: Value<String>(nowIsoUtc),
      ),
    );
  }
}
