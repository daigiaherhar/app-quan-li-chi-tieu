import 'package:drift/drift.dart';
import 'package:quan_ly_chi_tieu/core/database/database_connection.dart';

part 'app_database.g.dart';
part 'app_database_constants.dart';
part 'tables/user_profiles_table.dart';
part 'tables/wallets_table.dart';
part 'tables/categories_transaction_table.dart';
part 'tables/transactions_table.dart';
part 'tables/budgets_table.dart';
part 'tables/app_settings_table.dart';
part 'app_database_migration.dart';

@DriftDatabase(
  tables: <Type>[
    UserProfiles,
    Wallets,
    CategoriesTransaction,
    Transactions,
    Budgets,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openDatabaseConnection());

  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => buildAppMigrationStrategy(this);
}
