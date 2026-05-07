/// Where to render the currency symbol relative to the formatted amount.
enum CurrencySymbolPosition { prefix, suffix }

/// App-wide currency descriptor.
///
/// - [code]: ISO 4217 code stored in DB / DTOs (e.g. `VND`, `USD`).
/// - [displayLabel]: short label for large amount UI suffix (e.g. `VNĐ`, `USD`).
/// - [symbol]: typographic symbol used in formatted amounts (e.g. `₫`, `$`).
/// - [symbolPosition]: VND suffixes the symbol, USD prefixes it.
class AppCurrency {
  const AppCurrency({
    required this.code,
    required this.displayLabel,
    required this.symbol,
    required this.symbolPosition,
  });

  final String code;
  final String displayLabel;
  final String symbol;
  final CurrencySymbolPosition symbolPosition;
}

const AppCurrency kCurrencyVnd = AppCurrency(
  code: 'VND',
  displayLabel: 'VNĐ',
  symbol: '₫',
  symbolPosition: CurrencySymbolPosition.suffix,
);

const AppCurrency kCurrencyUsd = AppCurrency(
  code: 'USD',
  displayLabel: 'USD',
  symbol: r'$',
  symbolPosition: CurrencySymbolPosition.prefix,
);

/// Active currency for the whole app.
///
/// Switch the entire UI to USD by changing this single line to [kCurrencyUsd].
/// Note: existing rows in the DB keep their original currency_code; this only
/// affects how new amounts are displayed and formatted.
const AppCurrency kAppCurrency = kCurrencyVnd;
