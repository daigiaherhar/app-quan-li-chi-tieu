part of '../app_database.dart';

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get walletId => text().references(Wallets, #id)();
  TextColumn get toWalletId => text().nullable().references(Wallets, #id)();
  TextColumn get categoryId => text().nullable().references(
    CategoriesTransaction,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get amount => integer()();
  IntColumn get feeAmount => integer().withDefault(const Constant<int>(0))();
  TextColumn get currencyCode =>
      text().withDefault(const Constant<String>('VND'))();
  TextColumn get happenedAt => text()();
  TextColumn get note => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant<String>(kTransactionStatusPosted))();
  TextColumn get transferGroupId => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  @override
  List<String> get customConstraints => <String>[
    "CHECK (type IN ('income','expense','transfer'))",
    'CHECK (amount > 0)',
    'CHECK (fee_amount >= 0)',
    "CHECK (status IN ('pending','posted','voided'))",
    '''
CHECK (
  (type = 'transfer' AND to_wallet_id IS NOT NULL AND wallet_id <> to_wallet_id)
  OR
  (type IN ('income', 'expense') AND to_wallet_id IS NULL)
)
''',
  ];
}
