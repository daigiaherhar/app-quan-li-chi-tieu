import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart'
    show
        kDefaultExpenseCategoryId,
        kDefaultIncomeCategoryId,
        kTransactionTypeExpense,
        kTransactionTypeIncome;
import 'package:quan_ly_chi_tieu/features/categories_transaction/presentation/models/transaction_category_entity.dart';
import 'package:quan_ly_chi_tieu/core/utils/vnd_amount_input_format.dart';
import 'package:quan_ly_chi_tieu/features/transactions/domain/usecases/save_transaction_params.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transaction_state.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transactions_providers.dart';

class TransactionNotifier extends Notifier<TransactionState> {
  TransactionNotifier(this.kind);

  final TransactionFlowKind kind;

  static const TransactionCategoryEntity _defaultIncomeCategory =
      TransactionCategoryEntity(
        id: kDefaultIncomeCategoryId,
        label: 'Thu khác',
        icon: Icons.savings_outlined,
      );

  static const TransactionCategoryEntity _defaultExpenseCategory =
      TransactionCategoryEntity(
        id: kDefaultExpenseCategoryId,
        label: 'Chi khác',
        icon: Icons.category_outlined,
      );

  @override
  TransactionState build() {
    return TransactionState.initial(
      kind: kind,
      selectedIncomeCategory: _defaultIncomeCategory,
      selectedExpenseCategory: _defaultExpenseCategory,
    );
  }

  void selectIncomeCategory(TransactionCategoryEntity picked) {
    state = state.copyWith(selectedIncomeCategory: picked);
  }

  void selectExpenseCategory(TransactionCategoryEntity picked) {
    state = state.copyWith(selectedExpenseCategory: picked);
  }

  void selectHappenedAt(DateTime value) {
    state = state.copyWith(happenedAt: value);
  }

  bool validateForm({required String amountText, required String noteText}) {
    final String trimmedAmountText = amountText.trim();
    final String trimmedNoteText = noteText.trim();
    final int? amount = parseVndAmountDigits(trimmedAmountText);
    String? amountError;
    String? noteError;
    if (trimmedAmountText.isEmpty || amount == null) {
      amountError = 'Vui lòng nhập số tiền';
    } else if (amount <= 0) {
      amountError = 'Số tiền phải lớn hơn 0';
    } else if (amount > 999999999999) {
      amountError = 'Số tiền quá lớn';
    }
    if (trimmedNoteText.length > kMaxFormNoteLength) {
      noteError = 'Ghi chú tối đa $kMaxFormNoteLength ký tự';
    }
    state = state.copyWith(
      amountError: amountError,
      noteError: noteError,
      clearAmountError: amountError == null,
      clearNoteError: noteError == null,
    );
    return amountError == null && noteError == null;
  }

  Future<void> submit({
    required String amountText,
    required String noteText,
    required String walletId,
  }) async {
    if (!validateForm(amountText: amountText, noteText: noteText)) {
      return;
    }
    final int? amount = parseVndAmountDigits(amountText.trim());
    if (amount == null) {
      state = state.copyWith(amountError: 'Vui lòng nhập số tiền');
      return;
    }
    state = state.copyWith(
      submitStatus: TransactionSubmitStatus.submitting,
      clearErrorMessage: true,
    );
    final String transactionType = kind == TransactionFlowKind.income
        ? kTransactionTypeIncome
        : kTransactionTypeExpense;
    final String categoryId = state.selectedCategory.id;
    final Result<void> result = await ref
        .read(saveTransactionUseCaseProvider)
        .call(
          SaveTransactionParams(
            amount: amount,
            type: transactionType,
            categoryId: categoryId,
            note: noteText.trim(),
            happenedAt: state.happenedAt,
            walletId: walletId,
          ),
        );
    state = result.when(
      onSuccess: (_) =>
          state.copyWith(submitStatus: TransactionSubmitStatus.success),
      onFailure: (String _, int __, dynamic ___) => state.copyWith(
        submitStatus: TransactionSubmitStatus.failure,
        errorMessage: 'Không thể lưu giao dịch. Vui lòng thử lại.',
      ),
    );
  }

  void resetSubmitStatus() {
    final TransactionSubmitStatus status = state.submitStatus;
    if (status == TransactionSubmitStatus.success ||
        status == TransactionSubmitStatus.failure) {
      state = state.copyWith(
        submitStatus: TransactionSubmitStatus.idle,
        clearErrorMessage: true,
      );
    }
  }
}
