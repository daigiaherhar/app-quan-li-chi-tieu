import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/core/utils/vnd_amount_input_format.dart';
import 'package:quan_ly_chi_tieu/features/wallets/presentation/providers/add_wallet_state.dart';
import 'package:quan_ly_chi_tieu/features/wallets/presentation/providers/wallets_providers.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _openingBalanceController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  void _onSave() {
    ref.read(addWalletProvider.notifier).submit(
          nameText: _nameController.text,
          openingBalanceText: _openingBalanceController.text,
        );
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String hintText,
    required IconData icon,
    Widget? suffix,
    String? errorText,
  }) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: context.sizes.r12,
      borderSide: BorderSide(
        color: context.colors.border.withValues(alpha: 0.28),
      ),
    );
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: context.colors.cardSurface,
      prefixIcon: Icon(
        icon,
        color: context.colors.pastelIndigoOn,
        size: context.sizes.i20,
      ),
      suffix: suffix,
      errorText: errorText,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: context.sizes.r12,
        borderSide: BorderSide(
          color: context.colors.pastelIndigoOn.withValues(alpha: 0.58),
          width: 1.6,
        ),
      ),
      hintStyle: context.textStyles.bodyMedium.copyWith(
        color: context.colors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w(context),
        vertical: 16.w(context),
      ),
    );
  }

  Widget _sheetHandle(BuildContext context) {
    return Center(
      child: Container(
        width: math.min(80.w(context), MediaQuery.sizeOf(context).width * 0.22),
        height: 6.w(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              context.colors.textSecondary.withValues(alpha: 0.14),
              context.colors.textSecondary.withValues(alpha: 0.26),
            ],
          ),
          border: Border.all(
            color: context.colors.white.withValues(alpha: 0.65),
            width: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _headerCard(BuildContext context, {required bool isSubmitting}) {
    return Container(
      padding: EdgeInsets.all(16.w(context)),
      decoration: BoxDecoration(
        color: context.colors.dashboardBackground,
        borderRadius: context.sizes.r16,
        border: Border.all(
          color: context.colors.border.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 54.w(context),
            height: 54.w(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: context.colors.walletGradient,
              ),
              borderRadius: context.sizes.r16,
              border: Border.all(
                color: context.colors.white.withValues(alpha: 0.8),
              ),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: context.colors.pastelMintOn,
              size: context.sizes.i24,
            ),
          ),
          context.gap.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Thêm ví mới',
                  style: context.textStyles.h3.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                context.gap.h4,
                Text(
                  'Tên ví và số dư ban đầu là đủ để bắt đầu.',
                  style: context.textStyles.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            color: context.colors.textSecondary,
            tooltip: 'Đóng',
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String text) {
    return Text(
      text,
      style: context.textStyles.label.copyWith(
        color: context.colors.textSecondary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _saveButton(
    BuildContext context, {
    required Color accent,
    required Color accentSurface,
    required bool isSubmitting,
  }) {
    return SizedBox(
      height: 52.w(context),
      child: FilledButton(
        onPressed: isSubmitting ? null : _onSave,
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: context.colors.onPrimary,
          disabledBackgroundColor: accentSurface.withValues(alpha: 0.8),
          disabledForegroundColor: accent.withValues(alpha: 0.45),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: context.sizes.r14),
        ),
        child: isSubmitting
            ? SizedBox(
                width: 22.w(context),
                height: 22.w(context),
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: context.colors.onPrimary,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.check_rounded, size: context.sizes.i20),
                  context.gap.w8,
                  Text(
                    'Lưu ví',
                    style: context.textStyles.bodyLarge.copyWith(
                      color: context.colors.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AddWalletState>(addWalletProvider, (
      AddWalletState? previous,
      AddWalletState next,
    ) {
      if (previous?.isSuccess == false && next.isSuccess) {
        Navigator.of(context).pop();
        return;
      }
      final String? message = next.errorMessage;
      if (message != null && previous?.errorMessage != message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    });

    final AddWalletState walletState = ref.watch(addWalletProvider);
    final bool isSubmitting = walletState.isSubmitting;
    final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final double bottomSafe = MediaQuery.paddingOf(context).bottom;
    final Color accent = context.colors.pastelIndigoOn;
    final Color accentSurface = context.colors.pastelIndigo;

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
                  20.w(context),
                  14.w(context),
                  20.w(context),
                  20.w(context) + bottomSafe,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _sheetHandle(context),
                        context.gap.h16,
                        _headerCard(context, isSubmitting: isSubmitting),
                        context.gap.h24,
                        _fieldLabel(context, 'Tên ví'),
                        context.gap.h8,
                        TextField(
                          controller: _nameController,
                          autofocus: true,
                          enabled: !isSubmitting,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          decoration: _fieldDecoration(
                            context,
                            hintText: 'Ví dụ: Tiền mặt hằng ngày',
                            icon: Icons.drive_file_rename_outline_rounded,
                            errorText: walletState.nameError,
                          ),
                          style: context.textStyles.bodyLarge.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        context.gap.h20,
                        _fieldLabel(context, 'Số dư ban đầu'),
                        context.gap.h8,
                        TextField(
                          controller: _openingBalanceController,
                          enabled: !isSubmitting,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters:
                              const <GroupedThousandsInputFormatter>[
                                GroupedThousandsInputFormatter(
                                  formatDisplay:
                                      formatMoneyGroupedFromDigitString,
                                ),
                              ],
                          decoration: _fieldDecoration(
                            context,
                            hintText: '0 (có thể bỏ trống)',
                            icon: Icons.savings_rounded,
                            suffix: Text(
                              kAppCurrency.code,
                              style: context.textStyles.bodySmall.copyWith(
                                color: context.colors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          style: context.textStyles.bodyLarge.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          onSubmitted: (_) => _onSave(),
                        ),
                        context.gap.h8,
                        Text(
                          'Bạn có thể cập nhật số dư sau khi tạo ví.',
                          style: context.textStyles.bodySmall.copyWith(
                            color: context.colors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                        context.gap.h24,
                        _saveButton(
                          context,
                          accent: accent,
                          accentSurface: accentSurface,
                          isSubmitting: isSubmitting,
                        ),
                      ],
                    ),
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
