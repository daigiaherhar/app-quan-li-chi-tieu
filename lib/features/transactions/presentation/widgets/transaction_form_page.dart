import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/models/transaction_category_entity.dart';
import 'package:quan_ly_chi_tieu/core/models/transaction_wallet_entity.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/core/utils/vnd_amount_input_format.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transaction_notifier.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transaction_state.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/widgets/transaction_amount_hero.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/widgets/transaction_save_button.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/widgets/transaction_section_caption.dart';
import 'package:quan_ly_chi_tieu/features/transactions/presentation/widgets/transaction_select_row.dart';
import 'package:quan_ly_chi_tieu/generated/assets.dart';
import 'package:quan_ly_chi_tieu/shared/dialogs/dialogs.dart';

/// Shared form for add-income / add-expense — differs only by [kind] (accent colors & categories).
class TransactionFormPage extends ConsumerStatefulWidget {
  const TransactionFormPage({super.key, required this.kind});

  final TransactionFlowKind kind;

  @override
  ConsumerState<TransactionFormPage> createState() =>
      _TransactionFormPageState();
}

class _TransactionFormPageState extends ConsumerState<TransactionFormPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();
  String? _selectedWalletId;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  String _formatAmountInputDisplay(String rawDigits) {
    return formatMoneyGroupedFromDigitString(rawDigits);
  }

  Future<void> _pickDateTime(TransactionState state) async {
    final DateTime? picked = await pickDateTimeWithViLocale(
      context,
      state.happenedAt,
    );
    if (!mounted || picked == null) {
      return;
    }
    ref
        .read(transactionProvider(widget.kind).notifier)
        .selectHappenedAt(picked);
  }

  Future<void> _openCategorySheet(TransactionState state) async {
    final TransactionNotifier notifier =
        ref.read(transactionProvider(widget.kind).notifier);
    final bool isIncome = widget.kind == TransactionFlowKind.income;
    if (isIncome) {
      final TransactionCategoryEntity? picked =
          await showLabeledOptionPickerSheet<TransactionCategoryEntity>(
            context: context,
            title: 'Chọn nguồn thu',
            items: notifier.incomeCategoryOptions,
            labelOf: (TransactionCategoryEntity c) => c.label,
            iconOf: (TransactionCategoryEntity c) => c.icon,
            selected: state.selectedIncomeCategory,
            accentColor: context.colors.income,
            selectedSurfaceColor: context.colors.incomeSurface,
          );
      if (picked != null) {
        notifier.selectIncomeCategory(picked);
      }
      return;
    }
    final TransactionCategoryEntity? picked =
        await showLabeledOptionPickerSheet<TransactionCategoryEntity>(
          context: context,
          title: 'Chọn hạng mục chi',
          items: notifier.expenseCategoryOptions,
          labelOf: (TransactionCategoryEntity c) => c.label,
          iconOf: (TransactionCategoryEntity c) => c.icon,
          selected: state.selectedExpenseCategory,
          accentColor: context.colors.expense,
          selectedSurfaceColor: context.colors.expenseSurface,
        );
    if (picked != null) {
      notifier.selectExpenseCategory(picked);
    }
  }

  Future<void> _onSave() async {
    final TransactionState before = ref.read(transactionProvider(widget.kind));
    final List<TransactionWalletEntity> wallets = ref
        .read(transactionWalletOptionsProvider)
        .when(
          data: (List<TransactionWalletEntity> value) => value,
          loading: () => const <TransactionWalletEntity>[],
          error: (_, __) => const <TransactionWalletEntity>[],
        );
    final TransactionWalletEntity? selectedWallet = _resolveSelectedWallet(
      wallets,
    );
    if (selectedWallet == null) {
      return;
    }
    await ref
        .read(transactionProvider(widget.kind).notifier)
        .submit(
          amountText: _amountController.text,
          noteText: _noteController.text,
          walletId: selectedWallet.id,
        );
    final TransactionState after = ref.read(transactionProvider(widget.kind));
    if (before.amountError != after.amountError && after.amountError != null) {
      _amountFocus.requestFocus();
    }
  }

  TransactionWalletEntity? _resolveSelectedWallet(
    List<TransactionWalletEntity> wallets,
  ) {
    if (wallets.isEmpty) {
      return null;
    }
    final String? selectedWalletId = _selectedWalletId;
    if (selectedWalletId == null) {
      final TransactionWalletEntity firstWallet = wallets.first;
      _selectedWalletId = firstWallet.id;
      return firstWallet;
    }
    for (final TransactionWalletEntity wallet in wallets) {
      if (wallet.id == selectedWalletId) {
        return wallet;
      }
    }
    final TransactionWalletEntity firstWallet = wallets.first;
    _selectedWalletId = firstWallet.id;
    return firstWallet;
  }

  Future<void> _openWalletSheet(
    List<TransactionWalletEntity> wallets,
    TransactionWalletEntity selectedWallet,
    Color accent,
  ) async {
    final TransactionWalletEntity? picked =
        await showLabeledOptionPickerSheet<TransactionWalletEntity>(
      context: context,
      title: 'Chọn ví',
      items: wallets,
      labelOf: (TransactionWalletEntity wallet) => wallet.name,
      iconOf: (TransactionWalletEntity wallet) => wallet.icon,
      selected: selectedWallet,
      accentColor: accent,
      selectedSurfaceColor: context.colors.pastelIndigo.withValues(alpha: 0.4),
    );
    if (!mounted || picked == null) {
      return;
    }
    setState(() {
      _selectedWalletId = picked.id;
    });
  }

  void _handleSubmitSuccess(TransactionState next) {
    final String message = next.isIncome
        ? 'Đã lưu khoản thu'
        : 'Đã lưu khoản chi';
    final Color snackColor = next.isIncome
        ? context.colors.income
        : context.colors.expense;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: context.colors.onPrimary),
        ),
        backgroundColor: snackColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
    ref.read(transactionProvider(widget.kind).notifier).resetSubmitStatus();
    context.pop();
  }

  void _handleSubmitFailure(TransactionState next) {
    final String message = next.errorMessage ?? 'Đã xảy ra lỗi, thử lại nhé';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: context.colors.onPrimary),
        ),
        backgroundColor: context.colors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
    ref.read(transactionProvider(widget.kind).notifier).resetSubmitStatus();
  }

  void _listenSubmitStatus() {
    ref.listen<TransactionState>(transactionProvider(widget.kind), (
      TransactionState? previous,
      TransactionState next,
    ) {
      if (!mounted) {
        return;
      }
      final bool isNewSuccess =
          next.submitStatus == TransactionSubmitStatus.success &&
          previous?.submitStatus != TransactionSubmitStatus.success;
      if (isNewSuccess) {
        _handleSubmitSuccess(next);
        return;
      }
      final bool isNewFailure =
          next.submitStatus == TransactionSubmitStatus.failure &&
          previous?.submitStatus != TransactionSubmitStatus.failure;
      if (isNewFailure) {
        _handleSubmitFailure(next);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TransactionState state = ref.watch(transactionProvider(widget.kind));
    final AsyncValue<List<TransactionWalletEntity>> walletsAsync = ref.watch(
      transactionWalletOptionsProvider,
    );
    _listenSubmitStatus();
    final String dateTimeLabel = DateFormat(
      'dd/MM/yyyy · HH:mm',
      'vi_VN',
    ).format(state.happenedAt);

    final Color accent = state.isIncome
        ? context.colors.income
        : context.colors.expense;
    final Color surface = state.isIncome
        ? context.colors.incomeSurface
        : context.colors.expenseSurface;
    final Color gradientAccent = state.isIncome
        ? context.colors.pastelMint.withValues(alpha: 0.45)
        : context.colors.pastelPink.withValues(alpha: 0.38);
    final String title = state.isIncome ? 'Thêm thu nhập' : 'Thêm chi tiêu';
    final String heroHint = state.isIncome
        ? 'Nhập số tiền thu được'
        : 'Nhập số tiền đã chi';
    final IconData categoryIcon = state.selectedCategory.icon;
    final String categoryRowLabel = state.isIncome ? 'Thu từ đâu' : 'Hạng mục';
    final String saveLabel = state.isIncome ? 'Lưu khoản thu' : 'Lưu khoản chi';
    final List<Color> saveGradient = state.isIncome
        ? context.colors.incomeGradient
        : context.colors.expenseGradient;
    final String noteHint = state.isIncome
        ? 'Ví dụ: Lương tháng 5, dự án X…'
        : 'Ví dụ: Ăn trưa, xăng xe…';
    final String sLottie = state.isIncome
        ? Assets.assetLottie.savePig
        : Assets.assetLottie.lostPig;
    final List<TransactionWalletEntity> wallets = walletsAsync.when(
      data: (List<TransactionWalletEntity> value) => value,
      loading: () => const <TransactionWalletEntity>[],
      error: (_, __) => const <TransactionWalletEntity>[],
    );
    final TransactionWalletEntity? selectedWallet = _resolveSelectedWallet(
      wallets,
    );

    return Scaffold(
      backgroundColor: context.colors.dashboardBackground,
      appBar: AppBar(
        backgroundColor: context.colors.dashboardBackground,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: TextButton(
          onPressed: state.isSaving ? null : () => context.pop(),
          child: Text(
            'Hủy',
            style: context.textStyles.bodyLarge.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leadingWidth: 72.w(context),
        title: Text(
          title,
          style: context.textStyles.h3.copyWith(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20.w(context),
                0,
                20.w(context),
                MediaQuery.viewInsetsOf(context).bottom + 16.w(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const TransactionSectionCaption(text: 'Số tiền'),
                  context.gap.h12,
                  TransactionAmountHero(
                    amountController: _amountController,
                    amountFocus: _amountFocus,
                    amountError: state.amountError,
                    formatDisplay: _formatAmountInputDisplay,
                    accentColor: accent,
                    heroMiddleColor: surface,
                    heroGradientAccent: gradientAccent,
                    heroHint: heroHint,
                    sLottie: sLottie,
                  ),
                  context.gap.h24,
                  const TransactionSectionCaption(text: 'Chi tiết giao dịch'),
                  context.gap.h12,
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.cardSurface,
                      borderRadius: context.sizes.r16,
                      border: Border.all(
                        color: context.colors.border.withValues(alpha: 0.35),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: context.colors.cardShadow,
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        TransactionSelectRow(
                          icon: categoryIcon,
                          iconBackground: surface,
                          iconColor: accent,
                          label: categoryRowLabel,
                          value: state.selectedCategory.label,
                          onTap: state.isSaving
                              ? null
                              : () => _openCategorySheet(state),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w(context),
                          ),
                          child: Divider(
                            height: 1,
                            color: context.colors.divider,
                          ),
                        ),
                        TransactionSelectRow(
                          icon: Icons.account_balance_wallet_rounded,
                          iconBackground: context.colors.pastelIndigo
                              .withValues(alpha: 0.5),
                          iconColor: context.colors.pastelIndigoOn,
                          label: 'Ví',
                          value: selectedWallet?.name ?? 'Chưa có ví',
                          onTap: state.isSaving ||
                                  selectedWallet == null ||
                                  wallets.isEmpty
                              ? null
                              : () => _openWalletSheet(
                                    wallets,
                                    selectedWallet,
                                    accent,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w(context),
                          ),
                          child: Divider(
                            height: 1,
                            color: context.colors.divider,
                          ),
                        ),
                        TransactionSelectRow(
                          icon: Icons.schedule_rounded,
                          iconBackground: context.colors.pastelIndigo
                              .withValues(alpha: 0.55),
                          iconColor: context.colors.pastelIndigoOn,
                          label: 'Thời gian',
                          value: dateTimeLabel,
                          onTap: state.isSaving
                              ? null
                              : () => _pickDateTime(state),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            16.w(context),
                            8.w(context),
                            16.w(context),
                            16.w(context),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Ghi chú',
                                style: context.textStyles.bodySmall.copyWith(
                                  color: context.colors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              context.gap.h8,
                              Text(
                                'Tùy chọn · tối đa $kMaxFormNoteLength ký tự',
                                style: context.textStyles.label.copyWith(
                                  color: context.colors.textSecondary
                                      .withValues(alpha: 0.85),
                                ),
                              ),
                              context.gap.h12,
                              TextField(
                                controller: _noteController,
                                maxLines: 3,
                                maxLength: kMaxFormNoteLength,
                                enabled: !state.isSaving,
                                buildCounter:
                                    (
                                      BuildContext context, {
                                      required int currentLength,
                                      required bool isFocused,
                                      required int? maxLength,
                                    }) => null,
                                style: context.textStyles.bodyLarge.copyWith(
                                  color: context.colors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: context.colors.dashboardBackground,
                                  hintText: noteHint,
                                  hintStyle: context.textStyles.bodyMedium
                                      .copyWith(
                                        color: context.colors.textSecondary
                                            .withValues(alpha: 0.55),
                                      ),
                                  border: OutlineInputBorder(
                                    borderRadius: context.sizes.r12,
                                    borderSide: BorderSide(
                                      color: context.colors.border,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: context.sizes.r12,
                                    borderSide: BorderSide(
                                      color: context.colors.border.withValues(
                                        alpha: 0.45,
                                      ),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: context.sizes.r12,
                                    borderSide: BorderSide(
                                      color: accent,
                                      width: 1.5,
                                    ),
                                  ),
                                  errorText: state.noteError,
                                  errorMaxLines: 2,
                                  contentPadding: context.padding.all16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              20.w(context),
              10.w(context),
              20.w(context),
              12.w(context) + MediaQuery.paddingOf(context).bottom,
            ),
            child: TransactionSaveButton(
              label: saveLabel,
              gradientColors: saveGradient,
              shadowColor: accent.withValues(alpha: 0.38),
              isLoading: state.isSaving,
              onPressed: state.isSaving ? null : _onSave,
            ),
          ),
        ],
      ),
    );
  }
}
