import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/demo/demo_data.dart';
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';

part '../widgets/header/ledger_header.dart';
part '../widgets/body/ledger_body.dart';
part '../widgets/body/ledger_transaction_tile.dart';

/// Tab 1 — Sổ ghi (feature `ledger` + UI demo).
class LedgerPage extends StatefulWidget {
  const LedgerPage({
    super.key,
  });

  static final NumberFormat currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  int _chipIndex = 0;

  List<TransactionEntity> get _filteredTransactions {
    if (_chipIndex == 0) return kMockTransactions;
    if (_chipIndex == 1) {
      return kMockTransactions.where((t) => t.isExpense).toList();
    }
    return kMockTransactions.where((t) => t.isIncome).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.dashboardBackground,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _LedgerHeader(
              chipIndex: _chipIndex,
              onChipChanged: (int index) => setState(() => _chipIndex = index),
            ),
            Expanded(
              child: _LedgerBody(transactions: _filteredTransactions),
            ),
          ],
        ),
      ),
    );
  }
}
