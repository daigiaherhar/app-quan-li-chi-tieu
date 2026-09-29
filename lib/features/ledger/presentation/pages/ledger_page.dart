import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart'
    show kCategoryKindExpense, kCategoryKindIncome;
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';
import 'package:quan_ly_chi_tieu/core/utils/app_locale_format.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/presentation/models/transaction_category_entity.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/presentation/providers/categories_providers.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_notifier.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_providers.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_state.dart';

part '../widgets/header/ledger_header.dart';
part '../widgets/body/ledger_body.dart';
part '../widgets/body/ledger_transaction_tile.dart';
part '../widgets/dialogs/ledger_filter_sheets.dart';

class LedgerPage extends ConsumerWidget {
  const LedgerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LedgerState state = ref.watch(ledgerProvider);
    final LedgerNotifier notifier = ref.read(ledgerProvider.notifier);
    final AsyncValue<List<TransactionEntity>> transactionsAsync = ref.watch(
      ledgerTransactionsProvider,
    );

    return ColoredBox(
      color: context.colors.dashboardBackground,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _LedgerHeader(
              chipIndex: state.chipIndex,
              onChipChanged: notifier.selectTab,
              onOpenCategoryFilter: () => _showLedgerCategoryFilterSheet(
                context: context,
                ref: ref,
              ),
              onOpenDateFilter: () => _showLedgerDateFilterSheet(
                context: context,
                ref: ref,
              ),
              dateFilterLabel: _dateFilterLabel(state),
              categoryFilterLabel: state.selectedCategoryName,
              onClearDateFilter: notifier.clearDateFilter,
              onClearCategoryFilter: notifier.clearCategoryFilter,
            ),
            Expanded(
              child: transactionsAsync.when(
                data: (List<TransactionEntity> transactions) {
                  return _LedgerBody(
                    transactions: notifier.filterTransactions(transactions),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object error, StackTrace stackTrace) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w(context)),
                      child: Text(
                        'Không tải được sổ giao dịch.\n$error',
                        textAlign: TextAlign.center,
                        style: context.textStyles.bodyMedium.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _dateFilterLabel(LedgerState state) {
    final DateTime? date = state.selectedDate;
    switch (state.dateFilterMode) {
      case LedgerDateFilterMode.all:
        return null;
      case LedgerDateFilterMode.day:
        if (date == null) {
          return null;
        }
        return DateFormat('dd/MM/yyyy').format(date);
      case LedgerDateFilterMode.month:
        if (date == null) {
          return null;
        }
        return DateFormat('MM/yyyy').format(date);
      case LedgerDateFilterMode.year:
        if (date == null) {
          return null;
        }
        return DateFormat('yyyy').format(date);
    }
  }
}
