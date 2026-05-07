import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/models/transaction_category_entity.dart';

/// Distinguishes income vs expense flows — shared UI, different accent colors.
enum TransactionFlowKind { income, expense }

enum TransactionSubmitStatus { idle, submitting, success }

@immutable
class TransactionState {
  const TransactionState({
    required this.kind,
    required this.selectedIncomeCategory,
    required this.selectedExpenseCategory,
    required this.happenedAt,
    required this.amountError,
    required this.noteError,
    required this.submitStatus,
  });

  factory TransactionState.initial({
    required TransactionFlowKind kind,
    required TransactionCategoryEntity selectedIncomeCategory,
    required TransactionCategoryEntity selectedExpenseCategory,
  }) {
    return TransactionState(
      kind: kind,
      selectedIncomeCategory: selectedIncomeCategory,
      selectedExpenseCategory: selectedExpenseCategory,
      happenedAt: DateTime.now(),
      amountError: null,
      noteError: null,
      submitStatus: TransactionSubmitStatus.idle,
    );
  }

  final TransactionFlowKind kind;
  final TransactionCategoryEntity selectedIncomeCategory;
  final TransactionCategoryEntity selectedExpenseCategory;
  final DateTime happenedAt;
  final String? amountError;
  final String? noteError;
  final TransactionSubmitStatus submitStatus;

  bool get isIncome => kind == TransactionFlowKind.income;
  bool get isSaving => submitStatus == TransactionSubmitStatus.submitting;
  TransactionCategoryEntity get selectedCategory =>
      isIncome ? selectedIncomeCategory : selectedExpenseCategory;

  TransactionState copyWith({
    TransactionCategoryEntity? selectedIncomeCategory,
    TransactionCategoryEntity? selectedExpenseCategory,
    DateTime? happenedAt,
    String? amountError,
    String? noteError,
    bool clearAmountError = false,
    bool clearNoteError = false,
    TransactionSubmitStatus? submitStatus,
  }) {
    return TransactionState(
      kind: kind,
      selectedIncomeCategory:
          selectedIncomeCategory ?? this.selectedIncomeCategory,
      selectedExpenseCategory:
          selectedExpenseCategory ?? this.selectedExpenseCategory,
      happenedAt: happenedAt ?? this.happenedAt,
      amountError: clearAmountError ? null : (amountError ?? this.amountError),
      noteError: clearNoteError ? null : (noteError ?? this.noteError),
      submitStatus: submitStatus ?? this.submitStatus,
    );
  }
}
