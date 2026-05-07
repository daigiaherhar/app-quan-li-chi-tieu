part of 'app_database.dart';

MigrationStrategy buildAppMigrationStrategy(AppDatabase database) {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await database.customStatement('PRAGMA foreign_keys = ON;');
      await createMvpIndexes(database);
      await seedMvpData(database);
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 4) {
        await database.customStatement('PRAGMA foreign_keys = OFF;');
        await database.customStatement('DROP TABLE IF EXISTS transactions;');
        await database.customStatement('DROP TABLE IF EXISTS wallets;');
        await database.customStatement('DROP TABLE IF EXISTS categories;');
        await database.customStatement('DROP TABLE IF EXISTS budgets;');
        await database.customStatement('DROP TABLE IF EXISTS app_settings;');
        await m.createTable(database.wallets);
        await m.createTable(database.categories);
        await m.createTable(database.transactions);
        await m.createTable(database.budgets);
        await m.createTable(database.appSettings);
        await database.customStatement('PRAGMA foreign_keys = ON;');
        await createMvpIndexes(database);
        await seedMvpData(database);
      }
      if (from < 3) {
        await m.createTable(database.userProfiles);
      }
    },
    beforeOpen: (OpeningDetails details) async {
      await database.customStatement('PRAGMA foreign_keys = ON;');
    },
  );
}

Future<void> createMvpIndexes(AppDatabase database) async {
  await database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tx_happened_at ON transactions(happened_at DESC);',
  );
  await database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tx_wallet_date ON transactions(wallet_id, happened_at DESC);',
  );
  await database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tx_category_date ON transactions(category_id, happened_at DESC);',
  );
  await database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tx_type_date ON transactions(type, happened_at DESC);',
  );
  await database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_budgets_active_range ON budgets(is_active, start_date, end_date);',
  );
  await database.customStatement(
      '''
CREATE UNIQUE INDEX IF NOT EXISTS uq_wallet_default_active
ON wallets(is_default)
WHERE is_default = 1 AND deleted_at IS NULL;
''',
  );
  await database.customStatement(
      '''
CREATE UNIQUE INDEX IF NOT EXISTS uq_category_kind_name_parent_active
ON categories(kind, name, parent_id)
WHERE deleted_at IS NULL;
''',
  );
  await database.customStatement(
      '''
CREATE INDEX IF NOT EXISTS idx_tx_status_not_deleted
ON transactions(status)
WHERE deleted_at IS NULL;
''',
  );
}

Future<void> seedMvpData(AppDatabase database) async {
  final String nowIsoUtc = DateTime.now().toUtc().toIso8601String();
  await database.into(database.wallets).insertOnConflictUpdate(
      WalletsCompanion.insert(
        id: kDefaultWalletId,
        name: 'Mặc định',
        type: kWalletTypeCash,
        currencyCode: const Value<String>('VND'),
        openingBalance: const Value<int>(0),
        currentBalance: const Value<int>(0),
        isActive: const Value<int>(1),
        isDefault: const Value<int>(1),
        displayOrder: const Value<int>(0),
        createdAt: nowIsoUtc,
        updatedAt: nowIsoUtc,
      ),
  );
  await database.into(database.categories).insertOnConflictUpdate(
      CategoriesCompanion.insert(
        id: kDefaultIncomeCategoryId,
        name: 'Thu khác',
        kind: kCategoryKindIncome,
        isSystem: const Value<int>(1),
        isActive: const Value<int>(1),
        displayOrder: const Value<int>(999),
        createdAt: nowIsoUtc,
        updatedAt: nowIsoUtc,
      ),
  );
  await database.into(database.categories).insertOnConflictUpdate(
      CategoriesCompanion.insert(
        id: kDefaultExpenseCategoryId,
        name: 'Chi khác',
        kind: kCategoryKindExpense,
        isSystem: const Value<int>(1),
        isActive: const Value<int>(1),
        displayOrder: const Value<int>(999),
        createdAt: nowIsoUtc,
        updatedAt: nowIsoUtc,
      ),
  );
  await database.into(database.appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(
        id: const Value<int>(1),
        defaultCurrencyCode: const Value<String>('VND'),
        locale: const Value<String>('vi_VN'),
        dateFormat: const Value<String>('dd/MM/yyyy'),
        themeMode: const Value<String>(kThemeModeSystem),
        firstDayOfWeek: const Value<int>(1),
        createdAt: nowIsoUtc,
        updatedAt: nowIsoUtc,
      ),
  );
}
