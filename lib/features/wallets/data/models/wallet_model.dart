import 'package:drift/drift.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/entities/wallet_entity.dart';

/// Data-layer model mirroring the wallet row schema.
///
/// Used as a single shape for both reading (from Drift) and writing (to a
/// companion):
/// - For new wallets: leave [id] null — [toCompanion] will generate one.
/// - For read flows: use [WalletModel.fromDrift] then [toEntity].
class WalletModel {
  const WalletModel({
    this.id,
    required this.name,
    required this.type,
    this.openingBalance = 0,
    this.currentBalance = 0,
    this.isDefault = false,
  });

  factory WalletModel.fromDrift(Wallet row) {
    return WalletModel(
      id: row.id,
      name: row.name,
      type: row.type,
      openingBalance: row.openingBalance,
      currentBalance: row.currentBalance,
      isDefault: row.isDefault == 1,
    );
  }

  final String? id;
  final String name;
  final String type;
  final int openingBalance;
  final int currentBalance;
  final bool isDefault;

  WalletsCompanion toCompanion() {
    final String nowIsoUtc = DateTime.now().toUtc().toIso8601String();
    final String resolvedId =
        id ?? 'wallet_${DateTime.now().microsecondsSinceEpoch}';
    final int resolvedCurrentBalance =
        currentBalance == 0 ? openingBalance : currentBalance;
    return WalletsCompanion.insert(
      id: resolvedId,
      name: name,
      type: type,
      openingBalance: Value<int>(openingBalance),
      currentBalance: Value<int>(resolvedCurrentBalance),
      isActive: const Value<int>(1),
      isDefault: Value<int>(isDefault ? 1 : 0),
      displayOrder: const Value<int>(0),
      createdAt: nowIsoUtc,
      updatedAt: nowIsoUtc,
    );
  }
}

extension WalletModelToEntity on WalletModel {
  WalletEntity toEntity() {
    final String? walletId = id;
    assert(
      walletId != null,
      'WalletModel.id must be non-null when converting to WalletEntity',
    );
    return WalletEntity(
      id: walletId!,
      name: name,
      type: type,
      currentBalance: currentBalance,
      isDefault: isDefault,
    );
  }
}
