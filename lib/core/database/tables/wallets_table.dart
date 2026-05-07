part of '../app_database.dart';

class Wallets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get currencyCode =>
      text().withDefault(const Constant<String>('VND'))();
  IntColumn get openingBalance =>
      integer().withDefault(const Constant<int>(0))();
  IntColumn get currentBalance =>
      integer().withDefault(const Constant<int>(0))();
  IntColumn get isActive => integer().withDefault(const Constant<int>(1))();
  IntColumn get isDefault => integer().withDefault(const Constant<int>(0))();
  IntColumn get displayOrder => integer().withDefault(const Constant<int>(0))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  @override
  List<String> get customConstraints => <String>[
    "CHECK (type IN ('cash','bank','ewallet','other'))",
    'CHECK (is_active IN (0, 1))',
    'CHECK (is_default IN (0, 1))',
  ];
}
