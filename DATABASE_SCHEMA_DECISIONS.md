# Database Schema Decisions

This file finalizes database to-dos from the personal finance schema plan and maps SQL decisions to Drift.

## MVP Tables (Final)

The app now uses the following MVP tables in Drift (`lib/core/database/app_database.dart`):
- `wallets`
- `categories`
- `transactions`
- `budgets`
- `app_settings`

### Constraints and Keys
- **`wallets`**
  - `id TEXT PRIMARY KEY`
  - `type` is checked against: `cash|bank|ewallet|other`
  - `is_active` / `is_default` checked as `0|1`
  - soft-delete via nullable `deleted_at`
- **`categories`**
  - `id TEXT PRIMARY KEY`
  - `kind` is checked against: `income|expense`
  - self-reference `parent_id -> categories.id` with `ON DELETE SET NULL`
  - `is_system` / `is_active` checked as `0|1`
  - soft-delete via nullable `deleted_at`
- **`transactions`**
  - `id TEXT PRIMARY KEY`
  - FK: `wallet_id -> wallets.id` (required)
  - FK: `to_wallet_id -> wallets.id` (optional)
  - FK: `category_id -> categories.id ON DELETE SET NULL`
  - `amount > 0`
  - `fee_amount >= 0`
  - `type` checked against: `income|expense|transfer`
  - `status` checked against: `pending|posted|voided`
  - transfer/business `CHECK`:
    - transfer requires `to_wallet_id` and different source/target wallet
    - income/expense requires `to_wallet_id IS NULL`
  - soft-delete via nullable `deleted_at`
- **`budgets`**
  - `id TEXT PRIMARY KEY`
  - `scope_type` checked against: `global|category`
  - `period` checked against: `weekly|monthly|quarterly|yearly|custom`
  - `limit_amount > 0`
  - `alert_percent` checked between `1..100`
  - optional FK to `categories` and `wallets` with `ON DELETE SET NULL`
- **`app_settings`**
  - single-row semantics via `id` with `CHECK (id = 1)`
  - `theme_mode` checked against: `light|dark|system`
  - `first_day_of_week` checked between `1..7`

## Extensions and Cloud Sync Metadata (Finalized for Next Phase)

Phase-2 extension tables are accepted as the default roadmap:
- `recurring_transactions`
- `budget_alerts`
- `transaction_tags`
- `transaction_tag_maps`
- `transaction_attachments`
- `reminder_settings`
- `sync_meta`

For cloud-sync readiness, each syncable table should support:
- stable local id (`TEXT`, UUID/ULID style)
- soft-delete (`deleted_at`) when historical merge is required
- sync metadata in `sync_meta` (`server_id`, `last_synced_at`, `sync_status`, `version`, `device_id`)
- conflict baseline: last-write-wins + monotonic `version`

## Index and Data Rules (Final)

### Indexes
- `idx_tx_happened_at` on `transactions(happened_at DESC)`
- `idx_tx_wallet_date` on `transactions(wallet_id, happened_at DESC)`
- `idx_tx_category_date` on `transactions(category_id, happened_at DESC)`
- `idx_tx_type_date` on `transactions(type, happened_at DESC)`
- `idx_tx_status_not_deleted` partial index on `transactions(status)` where `deleted_at IS NULL`
- `idx_budgets_active_range` on `budgets(is_active, start_date, end_date)`
- `uq_wallet_default_active` unique partial index on `wallets(is_default)` where `is_default = 1 AND deleted_at IS NULL`
- `uq_category_kind_name_parent_active` unique partial index on `categories(kind, name, parent_id)` where `deleted_at IS NULL`

### Core Data Rules
- `transactions.amount` must be positive.
- Transfer must have `to_wallet_id` and cannot transfer to the same wallet.
- Income/expense must not have `to_wallet_id`.
- Category kind must match transaction intent in application-level validation.

### Wallet Balance Handling Rules
- `income`: add to source wallet balance.
- `expense`: subtract from source wallet balance.
- `transfer`: subtract from source wallet and add to destination wallet.
- Balance updates should be applied atomically in a transaction.
- Add a recovery routine (`recalculateWalletBalance(walletId)`) in the repository layer when sync/migration conflicts are introduced.

## SQL -> Drift Mapping and Migration Strategy

### Mapping Principles
- SQL `TEXT PRIMARY KEY` -> Drift `TextColumn` + `primaryKey`.
- SQL `CHECK` -> Drift `.check(...)` or `customConstraints`.
- SQL FK -> Drift `.references(...)` with explicit `onDelete` when needed.
- SQL partial index -> `customStatement('CREATE ... WHERE ...')` in migration.
- UTC ISO timestamps remain `TEXT` columns for predictable sync payload compatibility.

### Current Migration Strategy
- `schemaVersion = 4`.
- `onCreate`:
  - create all tables
  - enable FK (`PRAGMA foreign_keys = ON`)
  - create all indexes
  - seed defaults:
    - default wallet
    - default income/expense categories
    - single app settings row
- `onUpgrade` from older schema:
  - recreate MVP tables to enforce new constraints shape
  - keep `user_profiles` compatibility for existing profile feature
  - re-run index creation and seed logic
- `beforeOpen` always ensures FK is enabled.
