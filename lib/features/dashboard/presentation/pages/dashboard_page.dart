import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/demo/demo_data.dart';
import 'package:quan_ly_chi_tieu/core/entities/transaction.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
part '../widgets/header/header.dart';
part '../widgets/body/body.dart';
part '../widgets/body/quick_actions.dart';
part '../widgets/body/monthly_chart.dart';
part '../widgets/body/recent_transactions.dart';
part '../widgets/body/surface_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.dashboardBackground,
      child: const SafeArea(bottom: false, top: false, child: _DashboardBody()),
    );
  }
}

String _formatCurrency(num value) => DashboardPage._currency.format(value);

String _formatSignedCurrency(num value, {required bool isExpense}) {
  final String sign = isExpense ? '-' : '+';
  final String formatted = DashboardPage._currency.format(value.abs());
  return '$sign$formatted';
}

String _greetingText() {
  final int hour = DateTime.now().hour;
  if (hour < 11) return 'Chào buổi sáng';
  if (hour < 14) return 'Chào buổi trưa';
  if (hour < 18) return 'Chào buổi chiều';
  return 'Chào buổi tối';
}

String _greetingEmoji() {
  final int hour = DateTime.now().hour;
  if (hour < 11) return '☀️';
  if (hour < 18) return '👋';
  return '🌙';
}

const List<String> _vnMonthNames = <String>[
  'Tháng 1',
  'Tháng 2',
  'Tháng 3',
  'Tháng 4',
  'Tháng 5',
  'Tháng 6',
  'Tháng 7',
  'Tháng 8',
  'Tháng 9',
  'Tháng 10',
  'Tháng 11',
  'Tháng 12',
];

String _formatMonthLabel(DateTime date) {
  final String name = _vnMonthNames[date.month - 1];
  return '$name ${date.year}';
}
