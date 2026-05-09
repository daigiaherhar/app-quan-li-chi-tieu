import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/demo/demo_data.dart';
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';
import 'package:quan_ly_chi_tieu/core/utils/app_locale_format.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_state.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_notifier.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_providers.dart';

part '../widgets/header/ledger_header.dart';
part '../widgets/body/ledger_body.dart';
part '../widgets/body/ledger_transaction_tile.dart';

// /// Tab 1 — Sổ ghi (feature `ledger` + UI demo).
// class LedgerPage extends StatefulWidget {
//   const LedgerPage({super.key});
//
//   @override
//   State<LedgerPage> createState() => _LedgerPageState();
// }

class LedgerPage extends ConsumerWidget {
  const LedgerPage({super.key});

  // int _chipIndex = 0;
  //
  // List<TransactionEntity> get _filteredTransactions {
  //   if (_chipIndex == 0) return kMockTransactions;
  //   if (_chipIndex == 1) {
  //     return kMockTransactions.where((t) => t.isExpense).toList();
  //   }
  //   return kMockTransactions.where((t) => t.isIncome).toList();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ledgerProvider);
    final notifier = ref.read(ledgerProvider.notifier);

    return ColoredBox(
      color: context.colors.dashboardBackground,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _LedgerHeader(
              chipIndex: state.chipIndex,
              onChipChanged: (int index) => notifier.selectTab(index),
            ),
            Expanded(child: _LedgerBody(transactions: [])),
          ],
        ),
      ),
    );
  }
}
