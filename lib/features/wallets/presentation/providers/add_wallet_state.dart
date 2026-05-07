import 'package:flutter/foundation.dart';

enum AddWalletSubmitStatus { idle, submitting, success, failure }

@immutable
class AddWalletState {
  const AddWalletState({
    required this.selectedType,
    required this.nameError,
    required this.submitStatus,
    required this.errorMessage,
  });

  factory AddWalletState.initial({required String defaultType}) {
    return AddWalletState(
      selectedType: defaultType,
      nameError: null,
      submitStatus: AddWalletSubmitStatus.idle,
      errorMessage: null,
    );
  }

  final String selectedType;
  final String? nameError;
  final AddWalletSubmitStatus submitStatus;
  final String? errorMessage;

  bool get isSubmitting => submitStatus == AddWalletSubmitStatus.submitting;
  bool get isSuccess => submitStatus == AddWalletSubmitStatus.success;

  AddWalletState copyWith({
    String? selectedType,
    String? nameError,
    bool clearNameError = false,
    AddWalletSubmitStatus? submitStatus,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AddWalletState(
      selectedType: selectedType ?? this.selectedType,
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
