part of '../../pages/ledger_page.dart';

Future<void> _showLedgerDateFilterSheet({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final LedgerState current = ref.read(ledgerProvider);
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext sheetContext) {
      return SizedBox(
        height: MediaQuery.sizeOf(sheetContext).height * 0.7,
        child: _LedgerDateFilterSheet(
          initialMode: current.dateFilterMode,
          initialDate: current.selectedDate ?? DateTime.now(),
          onApply: (LedgerDateFilterMode mode, DateTime? date) {
            ref
                .read(ledgerProvider.notifier)
                .setDateFilter(mode: mode, date: date);
            Navigator.of(sheetContext).pop();
          },
          onClear: () {
            ref.read(ledgerProvider.notifier).clearDateFilter();
            Navigator.of(sheetContext).pop();
          },
        ),
      );
    },
  );
}

Future<void> _showLedgerCategoryFilterSheet({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final LedgerState current = ref.read(ledgerProvider);
  final String? kind = switch (current.tabTransaction) {
    TabTransaction.all => null,
    TabTransaction.income => kCategoryKindIncome,
    TabTransaction.expense => kCategoryKindExpense,
  };

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext sheetContext) {
      return SizedBox(
        height: MediaQuery.sizeOf(sheetContext).height * 0.7,
        child: Consumer(
          builder: (BuildContext context, WidgetRef sheetRef, Widget? child) {
            final AsyncValue<List<TransactionCategoryEntity>> categoriesAsync =
                sheetRef.watch(transactionCategoryOptionsProvider(kind));

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20.w(context),
                  12.w(context),
                  20.w(context),
                  24.w(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: context.colors.divider,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    context.gap.h16,
                    Text(
                      'Lọc theo hạng mục',
                      style: context.textStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    context.gap.h12,
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Tất cả hạng mục',
                        style: context.textStyles.bodyMedium.copyWith(
                          fontWeight: current.selectedCategoryId == null
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      trailing: current.selectedCategoryId == null
                          ? Icon(
                              Icons.check_rounded,
                              color: context.colors.primary,
                            )
                          : null,
                      onTap: () {
                        ref.read(ledgerProvider.notifier).clearCategoryFilter();
                        Navigator.of(sheetContext).pop();
                      },
                    ),
                    Expanded(
                      child: categoriesAsync.when(
                        data: (List<TransactionCategoryEntity> categories) {
                          if (categories.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 24.w(context),
                              ),
                              child: Text(
                                'Chưa có hạng mục',
                                textAlign: TextAlign.center,
                                style: context.textStyles.bodyMedium.copyWith(
                                  color: context.colors.textSecondary,
                                ),
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: categories.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              color: context.colors.divider,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              final TransactionCategoryEntity category =
                                  categories[index];
                              final bool selected =
                                  current.selectedCategoryId == category.id;
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  category.icon,
                                  color: selected
                                      ? context.colors.primary
                                      : context.colors.textSecondary,
                                ),
                                title: Text(
                                  category.label,
                                  style: context.textStyles.bodyMedium.copyWith(
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                                trailing: selected
                                    ? Icon(
                                        Icons.check_rounded,
                                        color: context.colors.primary,
                                      )
                                    : null,
                                onTap: () {
                                  ref
                                      .read(ledgerProvider.notifier)
                                      .selectCategory(
                                        categoryId: category.id,
                                        categoryName: category.label,
                                      );
                                  Navigator.of(sheetContext).pop();
                                },
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (Object error, StackTrace stackTrace) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 24.w(context),
                            ),
                            child: Text(
                              'Không tải được hạng mục.\n$error',
                              textAlign: TextAlign.center,
                              style: context.textStyles.bodyMedium.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

class _LedgerDateFilterSheet extends StatefulWidget {
  const _LedgerDateFilterSheet({
    required this.initialMode,
    required this.initialDate,
    required this.onApply,
    required this.onClear,
  });

  final LedgerDateFilterMode initialMode;
  final DateTime initialDate;
  final void Function(LedgerDateFilterMode mode, DateTime? date) onApply;
  final VoidCallback onClear;

  @override
  State<_LedgerDateFilterSheet> createState() => _LedgerDateFilterSheetState();
}

class _LedgerDateFilterSheetState extends State<_LedgerDateFilterSheet> {
  late LedgerDateFilterMode _mode;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _date = widget.initialDate;
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 1, 12, 31),
      helpText: switch (_mode) {
        LedgerDateFilterMode.day => 'Chọn ngày',
        LedgerDateFilterMode.month => 'Chọn tháng',
        LedgerDateFilterMode.year => 'Chọn năm',
        LedgerDateFilterMode.all => 'Chọn ngày',
      },
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  String get _dateLabel {
    return switch (_mode) {
      LedgerDateFilterMode.all => 'Không giới hạn',
      LedgerDateFilterMode.day => DateFormat('dd/MM/yyyy').format(_date),
      LedgerDateFilterMode.month => DateFormat('MM/yyyy').format(_date),
      LedgerDateFilterMode.year => DateFormat('yyyy').format(_date),
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20.w(context),
          12.w(context),
          20.w(context),
          24.w(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.divider,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            context.gap.h16,
            Text(
              'Lọc theo thời gian',
              style: context.textStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            context.gap.h16,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: LedgerDateFilterMode.values.map((
                LedgerDateFilterMode mode,
              ) {
                final bool selected = _mode == mode;
                return ChoiceChip(
                  label: Text(mode.label),
                  selected: selected,
                  onSelected: (_) => setState(() => _mode = mode),
                  selectedColor: context.colors.primary.withValues(alpha: 0.2),
                  labelStyle: context.textStyles.bodySmall.copyWith(
                    color: selected
                        ? context.colors.primary
                        : context.colors.textSecondary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                );
              }).toList(growable: false),
            ),
            if (_mode != LedgerDateFilterMode.all) ...<Widget>[
              context.gap.h16,
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.calendar_month_rounded,
                  color: context.colors.primary,
                ),
                title: Text(
                  _dateLabel,
                  style: context.textStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  'Chạm để chọn ${_mode.label.toLowerCase()}',
                  style: context.textStyles.label.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                onTap: _pickDate,
              ),
            ],
            const Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onClear,
                    child: const Text('Xóa lọc'),
                  ),
                ),
                context.gap.w12,
                Expanded(
                  child: FilledButton(
                    onPressed: () => widget.onApply(
                      _mode,
                      _mode == LedgerDateFilterMode.all ? null : _date,
                    ),
                    child: const Text('Áp dụng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
