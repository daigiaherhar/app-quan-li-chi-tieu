import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_state.dart';

class LedgerNotifier extends Notifier<LedgerState> {
  @override
  LedgerState build() {
    return LedgerState();
  }

  void selectTab(int index) {
    final TabTransaction tab = TabTransaction.values[index.clamp(
      0,
      TabTransaction.values.length - 1,
    )];
    state = state.copyWith(
      chipIndex: index,
      tabTransaction: tab,
      selectedCategoryId: null,
      selectedCategoryName: null,
    );
  }

  void setDateFilter({
    required LedgerDateFilterMode mode,
    DateTime? date,
  }) {
    state = state.copyWith(
      dateFilterMode: mode,
      selectedDate: mode == LedgerDateFilterMode.all ? null : date,
    );
  }

  void clearDateFilter() {
    state = state.copyWith(
      dateFilterMode: LedgerDateFilterMode.all,
      selectedDate: null,
    );
  }

  void selectCategory({
    required String categoryId,
    required String categoryName,
  }) {
    state = state.copyWith(
      selectedCategoryId: categoryId,
      selectedCategoryName: categoryName,
    );
  }

  void clearCategoryFilter() {
    state = state.copyWith(
      selectedCategoryId: null,
      selectedCategoryName: null,
    );
  }

  List<TransactionEntity> filterTransactions(
    List<TransactionEntity> transactions,
  ) {
    return transactions
        .where(_matchesTab)
        .where(_matchesDate)
        .where(_matchesCategory)
        .toList(growable: false);
  }

  bool _matchesTab(TransactionEntity item) {
    return switch (state.tabTransaction) {
      TabTransaction.all => true,
      TabTransaction.income => item.isIncome,
      TabTransaction.expense => item.isExpense,
    };
  }

  bool _matchesDate(TransactionEntity item) {
    final DateTime? selected = state.selectedDate;
    switch (state.dateFilterMode) {
      case LedgerDateFilterMode.all:
        return true;
      case LedgerDateFilterMode.day:
        if (selected == null) {
          return true;
        }
        return item.happenedAt.year == selected.year &&
            item.happenedAt.month == selected.month &&
            item.happenedAt.day == selected.day;
      case LedgerDateFilterMode.month:
        if (selected == null) {
          return true;
        }
        return item.happenedAt.year == selected.year &&
            item.happenedAt.month == selected.month;
      case LedgerDateFilterMode.year:
        if (selected == null) {
          return true;
        }
        return item.happenedAt.year == selected.year;
    }
  }

  bool _matchesCategory(TransactionEntity item) {
    final String? categoryId = state.selectedCategoryId;
    if (categoryId == null) {
      return true;
    }
    return item.categoryId == categoryId;
  }
}
