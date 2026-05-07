part of '../app_database.dart';

class UserProfiles extends Table {
  IntColumn get id => integer().withDefault(const Constant<int>(1))();
  TextColumn get displayName => text().nullable()();
  BoolColumn get hasUserInfo =>
      boolean().withDefault(const Constant<bool>(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => <Column<Object>>{id};
}
