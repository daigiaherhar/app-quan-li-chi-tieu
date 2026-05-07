import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transaction_state.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/widgets/transaction_form_page.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key, required this.kind});

  factory TransactionPage.fromRoute(GoRouterState state) {
    final Object? extra = state.extra;
    final TransactionFlowKind kind =
        extra is TransactionFlowKind ? extra : TransactionFlowKind.expense;
    return TransactionPage(kind: kind);
  }

  final TransactionFlowKind kind;

  @override
  Widget build(BuildContext context) {
    return TransactionFormPage(kind: kind);
  }
}
