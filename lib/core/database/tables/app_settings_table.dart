part of '../app_database.dart';

class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant<int>(1))();
  TextColumn get defaultCurrencyCode =>
      text().withDefault(const Constant<String>('VND'))();
  TextColumn get locale => text().withDefault(const Constant<String>('vi_VN'))();
  TextColumn get dateFormat =>
      text().withDefault(const Constant<String>('dd/MM/yyyy'))();
  TextColumn get themeMode =>
      text().withDefault(const Constant<String>(kThemeModeSystem))();
  IntColumn get firstDayOfWeek =>
      integer().withDefault(const Constant<int>(1))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  @override
  List<String> get customConstraints => <String>[
    'CHECK (id = 1)',
    "CHECK (theme_mode IN ('light','dark','system'))",
    'CHECK (first_day_of_week BETWEEN 1 AND 7)',
  ];
}
