part of '../app_database.dart';

class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get scopeType => text()();
  TextColumn get categoryId =>
      text().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  TextColumn get walletId =>
      text().nullable().references(Wallets, #id, onDelete: KeyAction.setNull)();
  IntColumn get limitAmount => integer()();
  IntColumn get spentAmount => integer().withDefault(const Constant<int>(0))();
  TextColumn get period => text()();
  TextColumn get startDate => text()();
  TextColumn get endDate => text()();
  IntColumn get alertPercent =>
      integer().withDefault(const Constant<int>(80))();
  IntColumn get isActive => integer().withDefault(const Constant<int>(1))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  @override
  List<String> get customConstraints => <String>[
    "CHECK (scope_type IN ('global','category'))",
    'CHECK (limit_amount > 0)',
    "CHECK (period IN ('weekly','monthly','quarterly','yearly','custom'))",
    'CHECK (alert_percent BETWEEN 1 AND 100)',
    'CHECK (is_active IN (0, 1))',
  ];
}
