import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart'
    show kCategoryKindExpense, kCategoryKindIncome, kTransactionTypeExpense;
import 'package:quan_ly_chi_tieu/core/models/transaction_wallet_entity.dart';
import 'package:quan_ly_chi_tieu/core/router/app_route_paths.dart';
import 'package:quan_ly_chi_tieu/core/utils/app_locale_format.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/presentation/models/transaction_category_entity.dart';
import 'package:quan_ly_chi_tieu/features/categories_transaction/presentation/providers/categories_providers.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/entities/ocr_transaction_result.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/presentation/providers/ocr_transaction_confirm_notifier.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/presentation/providers/ocr_transaction_confirm_state.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:quan_ly_chi_tieu/shared/widgets/widgets.dart';

part '../widgets/body/ocr_transaction_confirm_body.dart';
part '../widgets/footer/ocr_transaction_confirm_bottom_bar.dart';
part '../widgets/header/ocr_transaction_confirm_header.dart';

class OcrTransactionConfirmPage extends ConsumerWidget {
  const OcrTransactionConfirmPage({super.key, required this.result});

  static Widget fromRoute(GoRouterState state) {
    final Object? extra = state.extra;
    if (extra is OcrTransactionResult) {
      return OcrTransactionConfirmPage(result: extra);
    }
    return const _MissingOcrResultPage();
  }

  final OcrTransactionResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ocrTransactionConfirmProvider(result);
    final OcrTransactionConfirmState state = ref.watch(provider);
    final OcrTransactionConfirmNotifier notifier = ref.read(provider.notifier);
    final AsyncValue<List<TransactionWalletEntity>> walletsAsync = ref.watch(
      transactionWalletOptionsProvider,
    );
    final List<TransactionWalletEntity> wallets = walletsAsync.when(
      data: (List<TransactionWalletEntity> value) => value,
      loading: () => const <TransactionWalletEntity>[],
      error: (_, __) => const <TransactionWalletEntity>[],
    );
    final TransactionWalletEntity? selectedWallet = _resolveSelectedWallet(
      wallets,
      state.selectedWalletId,
    );
    final List<TransactionCategoryEntity> incomeCategories =
        _readCategoryOptions(ref, kCategoryKindIncome);
    final List<TransactionCategoryEntity> expenseCategories =
        _readCategoryOptions(ref, kCategoryKindExpense);

    ref.listen<OcrTransactionConfirmState>(provider, (
      OcrTransactionConfirmState? previous,
      OcrTransactionConfirmState next,
    ) {
      if (!context.mounted) {
        return;
      }
      if (next.isSuccess && previous?.isSuccess != true) {
        _showSnackBar(context, 'Đã lưu ${next.selectedCount} giao dịch.');
        notifier.resetSubmitStatus();
        context.go(AppRoutePaths.home);
        return;
      }
      if (next.isFailure && previous?.isFailure != true) {
        _showSnackBar(
          context,
          next.errorMessage ?? 'Không thể lưu giao dịch. Vui lòng thử lại.',
          isError: true,
        );
        notifier.resetSubmitStatus();
      }
    });

    return Scaffold(
      backgroundColor: context.colors.dashboardBackground,
      appBar: BaseAppBar(
        title: 'Xác nhận giao dịch',
        backgroundColor: context.colors.dashboardBackground,
        titleColor: context.colors.textPrimary,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colors.textPrimary,
          ),
        ),
      ),
      body: _OcrTransactionConfirmBody(
        result: result,
        state: state,
        walletsAsync: walletsAsync,
        selectedWallet: selectedWallet,
        onWalletTap: wallets.isEmpty
            ? null
            : () => _openWalletPicker(
                context: context,
                notifier: notifier,
                wallets: wallets,
                selectedWallet: selectedWallet,
              ),
        onTransactionChanged: notifier.setTransactionSelected,
        onSave: selectedWallet == null
            ? null
            : () => notifier.submitSelected(
                walletId: selectedWallet.id,
                incomeCategories: incomeCategories,
                expenseCategories: expenseCategories,
              ),
      ),
    );
  }

  List<TransactionCategoryEntity> _readCategoryOptions(
    WidgetRef ref,
    String kind,
  ) {
    return ref
        .watch(transactionCategoryOptionsProvider(kind))
        .when(
          data: (List<TransactionCategoryEntity> value) => value,
          loading: () => const <TransactionCategoryEntity>[],
          error: (_, __) => const <TransactionCategoryEntity>[],
        );
  }

  TransactionWalletEntity? _resolveSelectedWallet(
    List<TransactionWalletEntity> wallets,
    String? selectedWalletId,
  ) {
    if (wallets.isEmpty) {
      return null;
    }
    if (selectedWalletId == null) {
      return wallets.first;
    }
    for (final TransactionWalletEntity wallet in wallets) {
      if (wallet.id == selectedWalletId) {
        return wallet;
      }
    }
    return wallets.first;
  }

  Future<void> _openWalletPicker({
    required BuildContext context,
    required OcrTransactionConfirmNotifier notifier,
    required List<TransactionWalletEntity> wallets,
    required TransactionWalletEntity? selectedWallet,
  }) async {
    final TransactionWalletEntity? picked =
        await showLabeledOptionPickerSheet<TransactionWalletEntity>(
          context: context,
          title: 'Chọn ví',
          items: wallets,
          labelOf: (TransactionWalletEntity wallet) => wallet.name,
          iconOf: (TransactionWalletEntity wallet) => wallet.icon,
          selected: selectedWallet ?? wallets.first,
          accentColor: context.colors.primary,
          selectedSurfaceColor: context.colors.pastelIndigo,
        );
    if (!context.mounted || picked == null) {
      return;
    }
    notifier.selectWallet(picked.id);
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: context.colors.onPrimary),
          ),
          backgroundColor: isError
              ? context.colors.error
              : context.colors.income,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
