import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';

class TransactionTypeBottomSheet extends StatelessWidget {
  const TransactionTypeBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      isScrollControlled: true,
      builder: (context) => const TransactionTypeBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w(context), 24.w(context), 24.w(context),
            MediaQuery.paddingOf(context).bottom + 32.w(context)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            context.gap.h24,
            Text(
              'Thêm giao dịch',
              style: context.textStyles.h3.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            context.gap.h32,
            Row(
              children: [
                Expanded(
                  child: _TypeButton(
                    label: 'Khoản chi',
                    icon: Icons.north_east_rounded,
                    color: context.colors.expense,
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to add expense
                    },
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
                ),
                context.gap.w16,
                Expanded(
                  child: _TypeButton(
                    label: 'Khoản thu',
                    icon: Icons.south_west_rounded,
                    color: context.colors.income,
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to add income
                    },
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().slideY(begin: 1, end: 0, duration: 300.ms, curve: Curves.easeOutQuad);
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24.w(context)),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              context.gap.h16,
              Text(
                label,
                style: context.textStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
