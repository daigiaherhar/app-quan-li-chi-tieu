import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart' show kWalletTypeCash;
import 'package:quan_ly_chi_tieu/core/utils/vnd_amount_input_format.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/usecases/create_wallet_params.dart';
import 'package:quan_ly_chi_tieu/features/wallets/presentation/providers/add_wallet_state.dart';
import 'package:quan_ly_chi_tieu/features/wallets/presentation/providers/wallets_providers.dart';

class AddWalletNotifier extends Notifier<AddWalletState> {
  @override
  AddWalletState build() {
    return AddWalletState.initial(defaultType: kWalletTypeCash);
  }

  bool _validate({required String trimmedName}) {
    if (trimmedName.isEmpty) {
      state = state.copyWith(nameError: 'Nhập tên ví');
      return false;
    }
    state = state.copyWith(clearNameError: true);
    return true;
  }

  Future<void> submit({
    required String nameText,
    required String openingBalanceText,
  }) async {
    if (state.isSubmitting) {
      return;
    }
    final String trimmedName = nameText.trim();
    if (!_validate(trimmedName: trimmedName)) {
      return;
    }
    state = state.copyWith(
      submitStatus: AddWalletSubmitStatus.submitting,
      clearErrorMessage: true,
    );
    final int openingBalance = parseVndAmountDigits(openingBalanceText) ?? 0;
    final Result<void> result =
        await ref.read(createWalletUseCaseProvider).call(
              CreateWalletParams(
                name: trimmedName,
                type: state.selectedType,
                openingBalance: openingBalance,
              ),
            );
    state = result.when(
      onSuccess: (_) => state.copyWith(
        submitStatus: AddWalletSubmitStatus.success,
      ),
      onFailure: (String _, int __, dynamic ___) => state.copyWith(
        submitStatus: AddWalletSubmitStatus.failure,
        errorMessage: 'Không thể tạo ví. Vui lòng thử lại.',
      ),
    );
  }
}
