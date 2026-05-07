import 'package:quan_ly_chi_tieu/core/constants/app_currency.dart';
import 'package:quan_ly_chi_tieu/core/utils/vnd_amount_input_format.dart';

String _attachCurrencySymbol(String formattedAmount) {
  switch (kAppCurrency.symbolPosition) {
    case CurrencySymbolPosition.prefix:
      return '${kAppCurrency.symbol}$formattedAmount';
    case CurrencySymbolPosition.suffix:
      return '$formattedAmount ${kAppCurrency.symbol}';
  }
}

/// Formats [value] using grouped thousands and the active app currency.
String formatAppCurrency(num value) {
  return _attachCurrencySymbol(formatMoneyGroupedInt(value.round()));
}

/// Same as [formatAppCurrency] but with a leading +/- sign for income/expense.
String formatSignedAppCurrency(num value, {required bool isExpense}) {
  final String sign = isExpense ? '-' : '+';
  final String formatted = formatMoneyGroupedInt(value.abs().round());
  return '$sign${_attachCurrencySymbol(formatted)}';
}

String timeOfDayGreetingVi() {
  final int hour = DateTime.now().hour;
  if (hour < 11) return 'Chào buổi sáng';
  if (hour < 14) return 'Chào buổi trưa';
  if (hour < 18) return 'Chào buổi chiều';
  return 'Chào buổi tối';
}

String timeOfDayGreetingEmojiVi() {
  final int hour = DateTime.now().hour;
  if (hour < 11) return '☀️';
  if (hour < 18) return '👋';
  return '🌙';
}

const List<String> _vietnameseMonthNames = <String>[
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

String formatMonthYearVi(DateTime date) {
  final String name = _vietnameseMonthNames[date.month - 1];
  return '$name ${date.year}';
}
