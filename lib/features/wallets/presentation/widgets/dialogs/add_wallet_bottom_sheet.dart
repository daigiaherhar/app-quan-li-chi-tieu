import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/database/app_database.dart';
import 'package:quan_ly_chi_tieu/core/database/database_providers.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/core/utils/vnd_amount_input_format.dart';

/// Rounded sheet + form — matches styling of [showLabeledOptionPickerSheet].
Future<void> showAddWalletBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.22),
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return const _AddWalletBottomSheet();
    },
  );
}

class _AddWalletBottomSheet extends ConsumerStatefulWidget {
  const _AddWalletBottomSheet();

  @override
  ConsumerState<_AddWalletBottomSheet> createState() =>
      _AddWalletBottomSheetState();
}

class _AddWalletBottomSheetState extends ConsumerState<_AddWalletBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _openingBalanceController =
      TextEditingController();
  String _selectedType = kWalletTypeCash;
  bool _isSaving = false;

  static const List<({String value, String label, IconData icon})> _typeOptions =
      <({String value, String label, IconData icon})>[
    (
      value: kWalletTypeCash,
      label: 'Tiền mặt',
      icon: Icons.payments_rounded,
    ),
    (
      value: 'bank',
      label: 'Ngân hàng',
      icon: Icons.account_balance_rounded,
    ),
    (
      value: 'ewallet',
      label: 'Ví điện tử',
      icon: Icons.smartphone_rounded,
    ),
    (
      value: 'other',
      label: 'Khác',
      icon: Icons.category_rounded,
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(BuildContext context, String labelText) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: context.sizes.r12,
      borderSide: BorderSide(
        color: context.colors.border.withValues(alpha: 0.35),
      ),
    );
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: context.colors.dashboardBackground,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: context.sizes.r12,
        borderSide: BorderSide(
          color: context.colors.pastelIndigo.withValues(alpha: 0.85),
          width: 1.6,
        ),
      ),
      labelStyle: context.textStyles.bodySmall.copyWith(
        color: context.colors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  Future<void> _onSave() async {
    if (_isSaving) {
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() {
      _isSaving = true;
    });
    try {
      final String trimmedName = _nameController.text.trim();
      final int openingBalance =
          parseVndAmountDigits(_openingBalanceController.text) ?? 0;
      final String nowIsoUtc = DateTime.now().toUtc().toIso8601String();
      final String walletId =
          'wallet_${DateTime.now().microsecondsSinceEpoch}';
      final AppDatabase database = ref.read(appDatabaseProvider);
      await database.into(database.wallets).insert(
        WalletsCompanion.insert(
          id: walletId,
          name: trimmedName,
          type: _selectedType,
          openingBalance: Value<int>(openingBalance),
          currentBalance: Value<int>(openingBalance),
          isActive: const Value<int>(1),
          isDefault: const Value<int>(0),
          displayOrder: const Value<int>(0),
          createdAt: nowIsoUtc,
          updatedAt: nowIsoUtc,
        ),
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final double bottomSafe = MediaQuery.paddingOf(context).bottom;
    final Color accent = context.colors.pastelIndigo;

    return Padding(
      padding: EdgeInsets.only(top: 12.w(context)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.w(context)),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.w(context)),
          ),
          child: SafeArea(
            top: false,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24.w(context),
                  14.w(context),
                  24.w(context),
                  20.w(context) + bottomSafe,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: math.min(
                            80.w(context),
                            MediaQuery.sizeOf(context).width * 0.22,
                          ),
                          height: 6.w(context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                context.colors.textSecondary
                                    .withValues(alpha: 0.14),
                                context.colors.textSecondary
                                    .withValues(alpha: 0.26),
                              ],
                            ),
                            border: Border.all(
                              color: context.colors.white
                                  .withValues(alpha: 0.65),
                              width: 0.8,
                            ),
                          ),
                        ),
                      ),
                      context.gap.h16,
                      Text(
                        'Thêm ví mới',
                        style: context.textStyles.h3.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      context.gap.h8,
                      Text(
                        'Đặt tên, loại ví và số dư khởi tạo.',
                        style: context.textStyles.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                          height: 1.35,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      context.gap.h20,
                      Text(
                        'Tên ví',
                        style: context.textStyles.label.copyWith(
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      context.gap.h8,
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: _fieldDecoration(context, 'Ví dụ: Tiền mặt hàng ngày'),
                        style: context.textStyles.bodyLarge.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nhập tên ví';
                          }
                          return null;
                        },
                      ),
                      context.gap.h20,
                      Text(
                        'Loại ví',
                        style: context.textStyles.label.copyWith(
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      context.gap.h8,
                      Wrap(
                        spacing: 10.w(context),
                        runSpacing: 10.w(context),
                        children: _typeOptions.map(
                          (({String value, String label, IconData icon}) o) {
                            final bool selected = _selectedType == o.value;
                            return FilterChip(
                              selected: selected,
                              showCheckmark: false,
                              avatar: Icon(
                                o.icon,
                                size: 18.w(context),
                                color: selected
                                    ? accent
                                    : context.colors.textSecondary,
                              ),
                              label: Text(o.label),
                              labelStyle: context.textStyles.bodySmall.copyWith(
                                color: selected
                                    ? accent
                                    : context.colors.textPrimary,
                                fontWeight:
                                    selected ? FontWeight.w700 : FontWeight.w500,
                              ),
                              selectedColor:
                                  accent.withValues(alpha: 0.14),
                              backgroundColor: context.colors.cardSurface,
                              side: BorderSide(
                                color: selected
                                    ? accent.withValues(alpha: 0.45)
                                    : context.colors.border
                                        .withValues(alpha: 0.28),
                                width: selected ? 1.4 : 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: context.sizes.r12,
                              ),
                              onSelected: (_) {
                                setState(() {
                                  _selectedType = o.value;
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),
                      context.gap.h20,
                      Text(
                        'Số dư ban đầu',
                        style: context.textStyles.label.copyWith(
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      context.gap.h8,
                      TextFormField(
                        controller: _openingBalanceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: const <GroupedThousandsInputFormatter>[
                          GroupedThousandsInputFormatter(
                            formatDisplay: formatMoneyGroupedFromDigitString,
                          ),
                        ],
                        decoration: _fieldDecoration(
                          context,
                          '0 (có thể bỏ trống)',
                        ),
                        style: context.textStyles.bodyLarge.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      context.gap.h24,
                      SizedBox(
                        height: 52.w(context),
                        child: FilledButton(
                          onPressed: _isSaving ? null : _onSave,
                          style: FilledButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: context.colors.pastelIndigoOn,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: context.sizes.r14,
                            ),
                          ),
                          child: _isSaving
                              ? SizedBox(
                                  width: 22.w(context),
                                  height: 22.w(context),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: context.colors.pastelIndigoOn,
                                  ),
                                )
                              : Text(
                                  'Lưu ví',
                                  style: context.textStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
