part of '../app_database.dart';

@DataClassName('CategoryTransaction')
class CategoriesTransaction extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get kind => text()();
  TextColumn get iconKey => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  TextColumn get parentId => text().nullable().references(
    CategoriesTransaction,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get isSystem => integer().withDefault(const Constant<int>(0))();
  IntColumn get isActive => integer().withDefault(const Constant<int>(1))();
  IntColumn get displayOrder => integer().withDefault(const Constant<int>(0))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  @override
  List<String> get customConstraints => <String>[
    "CHECK (kind IN ('income','expense'))",
    'CHECK (is_system IN (0, 1))',
    'CHECK (is_active IN (0, 1))',
  ];
}
