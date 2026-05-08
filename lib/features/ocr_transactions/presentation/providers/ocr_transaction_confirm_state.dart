import 'package:flutter/foundation.dart';

enum OcrTransactionConfirmSubmitStatus { idle, submitting, success, failure }

@immutable
class OcrTransactionConfirmState {
  const OcrTransactionConfirmState({
    required this.selected,
    required this.selectedWalletId,
    required this.submitStatus,
    required this.errorMessage,
  });

  factory OcrTransactionConfirmState.initial({required int transactionCount}) {
    return OcrTransactionConfirmState(
      selected: List<bool>.unmodifiable(
        List<bool>.filled(transactionCount, true),
      ),
      selectedWalletId: null,
      submitStatus: OcrTransactionConfirmSubmitStatus.idle,
      errorMessage: null,
    );
  }

  final List<bool> selected;
  final String? selectedWalletId;
  final OcrTransactionConfirmSubmitStatus submitStatus;
  final String? errorMessage;

  bool get isSaving =>
      submitStatus == OcrTransactionConfirmSubmitStatus.submitting;
  bool get isSuccess =>
      submitStatus == OcrTransactionConfirmSubmitStatus.success;
  bool get isFailure =>
      submitStatus == OcrTransactionConfirmSubmitStatus.failure;
  int get selectedCount => selected.where((bool value) => value).length;

  OcrTransactionConfirmState copyWith({
    List<bool>? selected,
    String? selectedWalletId,
    bool clearSelectedWalletId = false,
    OcrTransactionConfirmSubmitStatus? submitStatus,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return OcrTransactionConfirmState(
      selected: selected == null
          ? this.selected
          : List<bool>.unmodifiable(selected),
      selectedWalletId: clearSelectedWalletId
          ? null
          : (selectedWalletId ?? this.selectedWalletId),
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
