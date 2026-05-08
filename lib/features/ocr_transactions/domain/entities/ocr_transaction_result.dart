class OcrTransactionResult {
  const OcrTransactionResult({
    required this.rawText,
    required this.transactions,
  });

  final String rawText;
  final List<OcrTransactionJson> transactions;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'rawText': rawText,
      'transactions': transactions
          .map((OcrTransactionJson transaction) => transaction.toJson())
          .toList(),
    };
  }
}

class OcrTransactionJson {
  const OcrTransactionJson({
    required this.type,
    required this.amount,
    required this.currencyCode,
    required this.note,
    required this.merchantName,
    required this.happenedAt,
    required this.categoryHint,
    required this.confidence,
  });

  factory OcrTransactionJson.fromJson(Map<String, dynamic> json) {
    return OcrTransactionJson(
      type: _readTransactionType(json['type']),
      amount: _readAmount(json['amount']),
      currencyCode: _readString(json['currencyCode'], fallback: 'VND'),
      note: _readString(json['note']),
      merchantName: _readNullableString(json['merchantName']),
      happenedAt: _readDateTime(json['happenedAt']),
      categoryHint: _readNullableString(json['categoryHint']),
      confidence: _readConfidence(json['confidence']),
    );
  }

  final String type;
  final int amount;
  final String currencyCode;
  final String note;
  final String? merchantName;
  final DateTime happenedAt;
  final String? categoryHint;
  final double confidence;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'amount': amount,
      'currencyCode': currencyCode,
      'note': note,
      'merchantName': merchantName,
      'happenedAt': happenedAt.toIso8601String(),
      'categoryHint': categoryHint,
      'confidence': confidence,
    };
  }

  static String _readTransactionType(Object? value) {
    final String normalized = value?.toString().trim().toLowerCase() ?? '';
    return normalized == 'income' ? 'income' : 'expense';
  }

  static int _readAmount(Object? value) {
    if (value is num) {
      return value.abs().round();
    }
    final String digits =
        value?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '';
    return int.tryParse(digits) ?? 0;
  }

  static String _readString(Object? value, {String fallback = ''}) {
    final String text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  static String? _readNullableString(Object? value) {
    final String text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  static DateTime _readDateTime(Object? value) {
    final DateTime now = DateTime.now();
    final DateTime? parsed = DateTime.tryParse(value?.toString() ?? '');
    return parsed ?? DateTime(now.year, now.month, now.day);
  }

  static double _readConfidence(Object? value) {
    final double confidence = switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };
    return confidence.clamp(0, 1).toDouble();
  }
}
