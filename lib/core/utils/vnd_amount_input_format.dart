import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Integer grouping with comma as thousands separator — use for all money amounts in app.
final NumberFormat kMoneyGroupedNumberFormat = NumberFormat('#,##0', 'en_US');

/// Formats an integer amount with `,` thousands separators (e.g. `1,234,567`).
String formatMoneyGroupedInt(int value) => kMoneyGroupedNumberFormat.format(value);

/// Strips non-digits, parses integer, returns grouped string; empty if invalid / empty.
String formatMoneyGroupedFromDigitString(String rawDigits) {
  final String digitsOnly = rawDigits.replaceAll(RegExp(r'\D'), '');
  if (digitsOnly.isEmpty) return '';
  final int? value = int.tryParse(digitsOnly);
  if (value == null) return '';
  return formatMoneyGroupedInt(value);
}

int? parseVndAmountDigits(String raw) {
  final String digitsOnly = raw.replaceAll(RegExp(r'\D'), '');
  if (digitsOnly.isEmpty) return null;
  return int.tryParse(digitsOnly);
}

/// Keeps only digits and reformats with [formatMoneyGroupedFromDigitString].
class GroupedThousandsInputFormatter extends TextInputFormatter {
  const GroupedThousandsInputFormatter({required this.formatDisplay});

  final String Function(String rawDigits) formatDisplay;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newDigits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (newDigits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    final String formatted = formatDisplay(newDigits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
