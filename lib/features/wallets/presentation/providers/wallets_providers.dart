import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/core/database/database_providers.dart';

final StreamProvider<List<Wallet>> walletsProvider =
    StreamProvider<List<Wallet>>((Ref ref) {
      final AppDatabase database = ref.watch(appDatabaseProvider);
      final query = database.select(database.wallets)
        ..where((table) => table.deletedAt.isNull())
        ..where((table) => table.isActive.equals(1));
      return query.watch().map((List<Wallet> rows) {
        final List<Wallet> wallets = List<Wallet>.from(rows);
        wallets.sort((Wallet a, Wallet b) {
          final int orderCompare = a.displayOrder.compareTo(b.displayOrder);
          if (orderCompare != 0) {
            return orderCompare;
          }
          return a.name.compareTo(b.name);
        });
        return wallets;
      });
    });
