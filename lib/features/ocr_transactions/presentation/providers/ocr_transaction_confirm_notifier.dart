import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart'
    show
        kDefaultExpenseCategoryId,
        kDefaultIncomeCategoryId,
        kTransactionTypeExpense,
        kTransactionTypeIncome;
import 'package:quan_ly_chi_tieu/features/categories_transaction/presentation/models/transaction_category_entity.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/entities/ocr_transaction_result.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/presentation/providers/ocr_transaction_confirm_state.dart';
import 'package:quan_ly_chi_tieu/features/transactions/domain/usecases/save_transaction_params.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transactions_providers.dart';

class OcrTransactionConfirmNotifier
    extends Notifier<OcrTransactionConfirmState> {
  OcrTransactionConfirmNotifier(this.result);

  final OcrTransactionResult result;

  @override
  OcrTransactionConfirmState build() {
    return OcrTransactionConfirmState.initial(
      transactionCount: result.transactions.length,
    );
  }

  void setTransactionSelected(int index, bool selected) {
    if (index < 0 || index >= state.selected.length) {
      return;
    }
    final List<bool> nextSelected = List<bool>.of(state.selected);
    nextSelected[index] = selected;
    state = state.copyWith(selected: nextSelected);
  }

  void selectWallet(String walletId) {
    state = state.copyWith(selectedWalletId: walletId);
  }

  Future<void> submitSelected({
    required String walletId,
    required List<TransactionCategoryEntity> incomeCategories,
    required List<TransactionCategoryEntity> expenseCategories,
  }) async {
    if (state.isSaving) {
      return;
    }
    final List<OcrTransactionJson> selectedTransactions =
        _selectedTransactions();
    if (selectedTransactions.isEmpty) {
      state = state.copyWith(
        submitStatus: OcrTransactionConfirmSubmitStatus.failure,
        errorMessage: 'Chưa chọn giao dịch nào.',
      );
      return;
    }

    state = state.copyWith(
      submitStatus: OcrTransactionConfirmSubmitStatus.submitting,
      clearErrorMessage: true,
    );
    for (final OcrTransactionJson transaction in selectedTransactions) {
      final Result<void> saveResult = await ref
          .read(saveTransactionUseCaseProvider)
          .call(
            _toSaveParams(
              transaction,
              walletId,
              incomeCategories: incomeCategories,
              expenseCategories: expenseCategories,
            ),
          );
      if (saveResult is Failure<void>) {
        state = state.copyWith(
          submitStatus: OcrTransactionConfirmSubmitStatus.failure,
          errorMessage: 'Không thể lưu giao dịch. Vui lòng thử lại.',
        );
        return;
      }
    }
    state = state.copyWith(
      submitStatus: OcrTransactionConfirmSubmitStatus.success,
    );
  }

  void resetSubmitStatus() {
    if (!state.isSuccess && !state.isFailure) {
      return;
    }
    state = state.copyWith(
      submitStatus: OcrTransactionConfirmSubmitStatus.idle,
      clearErrorMessage: true,
    );
  }

  List<OcrTransactionJson> _selectedTransactions() {
    return <OcrTransactionJson>[
      for (int index = 0; index < result.transactions.length; index++)
        if (state.selected[index]) result.transactions[index],
    ];
  }

  SaveTransactionParams _toSaveParams(
    OcrTransactionJson transaction,
    String walletId, {
    required List<TransactionCategoryEntity> incomeCategories,
    required List<TransactionCategoryEntity> expenseCategories,
  }) {
    final bool isIncome = transaction.type == kTransactionTypeIncome;
    return SaveTransactionParams(
      amount: transaction.amount,
      type: isIncome ? kTransactionTypeIncome : kTransactionTypeExpense,
      note: transaction.note,
      happenedAt: transaction.happenedAt,
      walletId: walletId,
      categoryId: _resolveCategoryId(
        transaction,
        categories: isIncome ? incomeCategories : expenseCategories,
        fallbackId: isIncome
            ? kDefaultIncomeCategoryId
            : kDefaultExpenseCategoryId,
      ),
    );
  }

  String _resolveCategoryId(
    OcrTransactionJson transaction, {
    required List<TransactionCategoryEntity> categories,
    required String fallbackId,
  }) {
    final String hint = _normalizeForMatch(transaction.categoryHint);
    if (hint.isEmpty) {
      return fallbackId;
    }
    for (final TransactionCategoryEntity category in categories) {
      final String label = _normalizeForMatch(category.label);
      if (label == hint || label.contains(hint) || hint.contains(label)) {
        return category.id;
      }
    }
    return fallbackId;
  }

  String _normalizeForMatch(String? value) {
    return value?.trim().toLowerCase() ?? '';
  }
}

final ocrTransactionConfirmProvider = NotifierProvider.autoDispose
    .family<
      OcrTransactionConfirmNotifier,
      OcrTransactionConfirmState,
      OcrTransactionResult
    >(OcrTransactionConfirmNotifier.new);
