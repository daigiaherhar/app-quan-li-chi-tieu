part of '../../pages/ocr_transaction_confirm_page.dart';

class _OcrTransactionConfirmBody extends StatelessWidget {
  const _OcrTransactionConfirmBody({
    required this.result,
    required this.state,
    required this.walletsAsync,
    required this.selectedWallet,
    required this.onWalletTap,
    required this.onTransactionChanged,
    required this.onSave,
  });

  final OcrTransactionResult result;
  final OcrTransactionConfirmState state;
  final AsyncValue<List<TransactionWalletEntity>> walletsAsync;
  final TransactionWalletEntity? selectedWallet;
  final VoidCallback? onWalletTap;
  final void Function(int index, bool selected) onTransactionChanged;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      top: false,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                16.w(context),
                12.w(context),
                16.w(context),
                16.w(context),
              ),
              children: <Widget>[
                _OcrConfirmSummaryHeader(
                  totalCount: result.transactions.length,
                  selectedCount: state.selectedCount,
                ),
                context.gap.h12,
                _OcrWalletPickerCard(
                  selectedWallet: selectedWallet,
                  isLoading: walletsAsync.isLoading,
                  onTap: onWalletTap,
                ),
                context.gap.h12,
                for (
                  int index = 0;
                  index < result.transactions.length;
                  index++
                ) ...<Widget>[
                  _OcrConfirmTransactionTile(
                    transaction: result.transactions[index],
                    selected: state.selected[index],
                    onChanged: (bool? value) {
                      onTransactionChanged(index, value ?? false);
                    },
                  ),
                  if (index != result.transactions.length - 1) context.gap.h10,
                ],
              ],
            ),
          ),
          _OcrConfirmBottomBar(
            selectedCount: state.selectedCount,
            isSaving: state.isSaving,
            canSave: state.selectedCount > 0 && selectedWallet != null,
            bottomSafe: bottomSafe,
            onSave: onSave,
          ),
        ],
      ),
    );
  }
}

class _OcrWalletPickerCard extends StatelessWidget {
  const _OcrWalletPickerCard({
    required this.selectedWallet,
    required this.isLoading,
    required this.onTap,
  });

  final TransactionWalletEntity? selectedWallet;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TransactionWalletEntity? wallet = selectedWallet;
    return Material(
      color: context.colors.surface,
      borderRadius: context.sizes.r16,
      child: InkWell(
        onTap: onTap,
        borderRadius: context.sizes.r16,
        child: Padding(
          padding: EdgeInsets.all(14.w(context)),
          child: Row(
            children: <Widget>[
              Container(
                width: 42.w(context),
                height: 42.w(context),
                decoration: BoxDecoration(
                  color: context.colors.incomeSurface,
                  borderRadius: context.sizes.r14,
                ),
                child: Icon(
                  wallet?.icon ?? Icons.account_balance_wallet_rounded,
                  color: context.colors.income,
                ),
              ),
              context.gap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Ví lưu giao dịch',
                      style: context.textStyles.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    context.gap.h2,
                    Text(
                      isLoading
                          ? 'Đang tải ví...'
                          : wallet?.name ?? 'Chưa có ví',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodyMedium.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: context.colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OcrConfirmTransactionTile extends StatelessWidget {
  const _OcrConfirmTransactionTile({
    required this.transaction,
    required this.selected,
    required this.onChanged,
  });

  final OcrTransactionJson transaction;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isExpense = transaction.type == kTransactionTypeExpense;
    final Color accent = isExpense
        ? context.colors.expense
        : context.colors.income;
    final String title = transaction.merchantName ?? transaction.note;
    final String amountText = formatSignedAppCurrency(
      transaction.amount,
      isExpense: isExpense,
    );
    return Material(
      color: context.colors.surface,
      borderRadius: context.sizes.r16,
      child: InkWell(
        onTap: () => onChanged(!selected),
        borderRadius: context.sizes.r16,
        child: Padding(
          padding: EdgeInsets.all(12.w(context)),
          child: Row(
            children: <Widget>[
              Checkbox(
                value: selected,
                onChanged: onChanged,
                activeColor: accent,
                visualDensity: VisualDensity.compact,
              ),
              context.gap.w8,
              Container(
                width: 42.w(context),
                height: 42.w(context),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: context.sizes.r14,
                ),
                child: Icon(
                  isExpense
                      ? Icons.north_east_rounded
                      : Icons.south_west_rounded,
                  color: accent,
                  size: context.sizes.i20,
                ),
              ),
              context.gap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodyMedium.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    context.gap.h4,
                    Text(
                      _buildSubtitle(transaction),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              context.gap.w12,
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 118.w(context)),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    amountText,
                    maxLines: 1,
                    style: context.textStyles.bodyMedium.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildSubtitle(OcrTransactionJson transaction) {
    final String category = transaction.categoryHint ?? 'Chưa rõ hạng mục';
    final String date = DateFormat(
      'HH:mm - dd/MM/yyyy',
      'vi_VN',
    ).format(transaction.happenedAt);
    return '$category - $date';
  }
}

class _MissingOcrResultPage extends StatelessWidget {
  const _MissingOcrResultPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.dashboardBackground,
      appBar: BaseAppBar(
        title: 'Xác nhận giao dịch',
        backgroundColor: context.colors.dashboardBackground,
        titleColor: context.colors.textPrimary,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w(context)),
          child: Text(
            'Không có dữ liệu quét.',
            textAlign: TextAlign.center,
            style: context.textStyles.bodyMedium.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
