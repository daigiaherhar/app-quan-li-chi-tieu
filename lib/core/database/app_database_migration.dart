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
      if (from < 3) {
        await m.createTable(database.userProfiles);
      }
      if (from < 6) {
        await database.customStatement('PRAGMA foreign_keys = OFF;');
        await database.customStatement('DROP TABLE IF EXISTS transactions;');
        await database.customStatement('DROP TABLE IF EXISTS wallets;');
        await database.customStatement('DROP TABLE IF EXISTS categories;');
        await database.customStatement(
          'DROP TABLE IF EXISTS transaction_categories;',
        );
        await database.customStatement(
          'DROP TABLE IF EXISTS categories_transaction;',
        );
        await database.customStatement('DROP TABLE IF EXISTS budgets;');
        await database.customStatement('DROP TABLE IF EXISTS app_settings;');
        await m.createTable(database.wallets);
        await m.createTable(database.categoriesTransaction);
        await m.createTable(database.transactions);
        await m.createTable(database.budgets);
        await m.createTable(database.appSettings);
        await database.customStatement('PRAGMA foreign_keys = ON;');
        await createMvpIndexes(database);
        await seedMvpData(database);
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
  await database.customStatement('''
CREATE UNIQUE INDEX IF NOT EXISTS uq_wallet_default_active
ON wallets(is_default)
WHERE is_default = 1 AND deleted_at IS NULL;
''');
  await database.customStatement('''
CREATE UNIQUE INDEX IF NOT EXISTS uq_category_kind_name_parent_active
ON categories_transaction(kind, name, parent_id)
WHERE deleted_at IS NULL;
''');
  await database.customStatement('''
CREATE INDEX IF NOT EXISTS idx_tx_status_not_deleted
ON transactions(status)
WHERE deleted_at IS NULL;
''');
}

Future<void> seedMvpData(AppDatabase database) async {
  final String nowIsoUtc = DateTime.now().toUtc().toIso8601String();
  await database
      .into(database.wallets)
      .insertOnConflictUpdate(
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
  await seedTransactionCategories(database, nowIsoUtc);
  await database
      .into(database.appSettings)
      .insertOnConflictUpdate(
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

Future<void> seedTransactionCategories(
  AppDatabase database,
  String nowIsoUtc,
) async {
  const List<_TransactionCategorySeed> seeds = <_TransactionCategorySeed>[
    _TransactionCategorySeed(
      'salary',
      'Lương',
      'salary',
      kCategoryKindIncome,
      10,
    ),
    _TransactionCategorySeed(
      'bonus',
      'Thưởng',
      'bonus',
      kCategoryKindIncome,
      20,
    ),
    _TransactionCategorySeed(
      'freelance',
      'Freelance',
      'freelance',
      kCategoryKindIncome,
      30,
    ),
    _TransactionCategorySeed(
      'business',
      'Kinh doanh',
      'business',
      kCategoryKindIncome,
      40,
    ),
    _TransactionCategorySeed(
      'investment',
      'Đầu tư',
      'investment',
      kCategoryKindIncome,
      50,
    ),
    _TransactionCategorySeed(
      'refund',
      'Hoàn tiền',
      'refund',
      kCategoryKindIncome,
      60,
    ),
    _TransactionCategorySeed(
      'gift',
      'Quà tặng',
      'gift',
      kCategoryKindIncome,
      70,
    ),
    _TransactionCategorySeed(
      kDefaultIncomeCategoryId,
      'Thu khác',
      'other_income',
      kCategoryKindIncome,
      999,
    ),
    _TransactionCategorySeed(
      'food',
      'Ăn uống',
      'food',
      kCategoryKindExpense,
      10,
    ),
    _TransactionCategorySeed(
      'transport',
      'Đi lại',
      'transport',
      kCategoryKindExpense,
      20,
    ),
    _TransactionCategorySeed(
      'shopping',
      'Mua sắm',
      'shopping',
      kCategoryKindExpense,
      30,
    ),
    _TransactionCategorySeed(
      'bills',
      'Hóa đơn',
      'bills',
      kCategoryKindExpense,
      40,
    ),
    _TransactionCategorySeed(
      'entertainment',
      'Giải trí',
      'entertainment',
      kCategoryKindExpense,
      50,
    ),
    _TransactionCategorySeed(
      'health',
      'Sức khỏe',
      'health',
      kCategoryKindExpense,
      60,
    ),
    _TransactionCategorySeed(
      'education',
      'Học tập',
      'education',
      kCategoryKindExpense,
      70,
    ),
    _TransactionCategorySeed(
      'family',
      'Gia đình',
      'family',
      kCategoryKindExpense,
      80,
    ),
    _TransactionCategorySeed(
      kDefaultExpenseCategoryId,
      'Chi khác',
      'other_expense',
      kCategoryKindExpense,
      999,
    ),
  ];
  for (final _TransactionCategorySeed seed in seeds) {
    await database
        .into(database.categoriesTransaction)
        .insertOnConflictUpdate(
          CategoriesTransactionCompanion.insert(
            id: seed.id,
            name: seed.name,
            kind: seed.kind,
            iconKey: Value<String>(seed.iconKey),
            isSystem: const Value<int>(1),
            isActive: const Value<int>(1),
            displayOrder: Value<int>(seed.displayOrder),
            createdAt: nowIsoUtc,
            updatedAt: nowIsoUtc,
          ),
        );
  }
}

class _TransactionCategorySeed {
  const _TransactionCategorySeed(
    this.id,
    this.name,
    this.iconKey,
    this.kind,
    this.displayOrder,
  );

  final String id;
  final String name;
  final String iconKey;
  final String kind;
  final int displayOrder;
}
