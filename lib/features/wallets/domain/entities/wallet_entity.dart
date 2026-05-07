import 'package:flutter/foundation.dart';

/// UI-facing representation of a wallet.
///
/// Holds only fields the presentation layer needs and exposes booleans instead
/// of the 0/1 flags stored in SQLite. Soft-delete and ordering columns are
/// resolved by the data layer and intentionally hidden here.
@immutable
class WalletEntity {
  const WalletEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.currentBalance,
    required this.isDefault,
  });

  final String id;
  final String name;
  final String type;
  final int currentBalance;
  final bool isDefault;
}
