import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/core/models/transaction_category_entity.dart';
import 'package:quan_ly_chi_tieu/core/utils/vnd_amount_input_format.dart';
import 'package:quan_ly_chi_tieu/features/transactions/data/models/transaction_dto.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transaction_state.dart';

class TransactionNotifier extends Notifier<TransactionState> {
  TransactionNotifier(this.kind);

  final TransactionFlowKind kind;

  // TODO: Replace these mock categories with repository/API data.
  static const List<TransactionCategoryEntity> _incomeCategories =
      <TransactionCategoryEntity>[
    TransactionCategoryEntity(
      id: 'salary',
      label: 'Lương',
      icon: Icons.payments_outlined,
    ),
    TransactionCategoryEntity(
      id: 'bonus',
      label: 'Thưởng',
      icon: Icons.celebration_outlined,
    ),
    TransactionCategoryEntity(
      id: 'freelance',
      label: 'Freelance',
      icon: Icons.laptop_mac_outlined,
    ),
    TransactionCategoryEntity(
      id: 'business',
      label: 'Kinh doanh',
      icon: Icons.storefront_outlined,
    ),
    TransactionCategoryEntity(
      id: 'investment',
      label: 'Đầu tư',
      icon: Icons.trending_up_rounded,
    ),
    TransactionCategoryEntity(
      id: 'refund',
      label: 'Hoàn tiền',
      icon: Icons.replay_rounded,
    ),
    TransactionCategoryEntity(
      id: 'gift',
      label: 'Quà tặng',
      icon: Icons.redeem_outlined,
    ),
    TransactionCategoryEntity(
      id: 'other_income',
      label: 'Thu khác',
      icon: Icons.savings_outlined,
    ),
  ];

  static const List<TransactionCategoryEntity> _expenseCategories =
      <TransactionCategoryEntity>[
    TransactionCategoryEntity(
      id: 'food',
      label: 'Ăn uống',
      icon: Icons.restaurant_outlined,
    ),
    TransactionCategoryEntity(
      id: 'transport',
      label: 'Đi lại',
      icon: Icons.directions_car_outlined,
    ),
    TransactionCategoryEntity(
      id: 'shopping',
      label: 'Mua sắm',
      icon: Icons.shopping_bag_outlined,
    ),
    TransactionCategoryEntity(
      id: 'bills',
      label: 'Hóa đơn',
      icon: Icons.receipt_long_outlined,
    ),
    TransactionCategoryEntity(
      id: 'entertainment',
      label: 'Giải trí',
      icon: Icons.movie_outlined,
    ),
    TransactionCategoryEntity(
      id: 'health',
      label: 'Sức khỏe',
      icon: Icons.favorite_outline_rounded,
    ),
    TransactionCategoryEntity(
      id: 'education',
      label: 'Học tập',
      icon: Icons.school_outlined,
    ),
    TransactionCategoryEntity(
      id: 'family',
      label: 'Gia đình',
      icon: Icons.family_restroom_outlined,
    ),
    TransactionCategoryEntity(
      id: 'other_expense',
      label: 'Chi khác',
      icon: Icons.category_outlined,
    ),
  ];

  List<TransactionCategoryEntity> get incomeCategoryOptions => _incomeCategories;
  List<TransactionCategoryEntity> get expenseCategoryOptions =>
      _expenseCategories;

  @override
  TransactionState build() {
    return TransactionState.initial(
      kind: kind,
      selectedIncomeCategory: _incomeCategories.last,
      selectedExpenseCategory: _expenseCategories.last,
    );
  }

  void selectIncomeCategory(TransactionCategoryEntity picked) {
    state = state.copyWith(
      selectedIncomeCategory: picked,
    );
  }

  void selectExpenseCategory(TransactionCategoryEntity picked) {
    state = state.copyWith(
      selectedExpenseCategory: picked,
    );
  }

  void selectHappenedAt(DateTime value) {
    state = state.copyWith(happenedAt: value);
  }

  bool validateForm({
    required String amountText,
    required String noteText,
  }) {
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
    state = state.copyWith(submitStatus: TransactionSubmitStatus.submitting);
    final int? amount = parseVndAmountDigits(amountText.trim());
    if (amount == null) {
      state = state.copyWith(
        submitStatus: TransactionSubmitStatus.idle,
        amountError: 'Vui lòng nhập số tiền',
      );
      return;
    }
    final String transactionType = kind == TransactionFlowKind.income
        ? kTransactionTypeIncome
        : kTransactionTypeExpense;
    final String categoryId = kind == TransactionFlowKind.income
        ? kDefaultIncomeCategoryId
        : kDefaultExpenseCategoryId;
    final TransactionDto dto = TransactionDto(
      amount: amount,
      type: transactionType,
      categoryId: categoryId,
      note: noteText.trim(),
      happenedAt: state.happenedAt,
      walletId: walletId,
    );
    final localDataSource = ref.read(transactionLocalDataSourceProvider);
    await localDataSource.saveTransaction(dto);
    state = state.copyWith(submitStatus: TransactionSubmitStatus.success);
  }

  void resetSubmitStatus() {
    if (state.submitStatus == TransactionSubmitStatus.success) {
      state = state.copyWith(submitStatus: TransactionSubmitStatus.idle);
    }
  }
}
