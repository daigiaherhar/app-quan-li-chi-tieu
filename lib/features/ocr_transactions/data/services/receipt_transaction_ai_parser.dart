import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/entities/ocr_transaction_result.dart';

class ReceiptTransactionAiParser {
  static const String _model = String.fromEnvironment(
    'FIREBASE_AI_MODEL',
    defaultValue: 'gemini-2.5-flash',
  );

  static final Schema _transactionSchema = Schema.object(
    properties: <String, Schema>{
      'type': Schema.enumString(
        enumValues: <String>['income', 'expense'],
        description: 'Transaction direction. Receipts are usually expense.',
      ),
      'amount': Schema.integer(
        minimum: 0,
        description: 'Absolute transaction amount in VND.',
      ),
      'currencyCode': Schema.enumString(enumValues: <String>['VND']),
      'note': Schema.string(
        description: 'Short Vietnamese note for the transaction.',
      ),
      'merchantName': Schema.string(nullable: true),
      'happenedAt': Schema.string(
        description: 'ISO-8601 date time inferred from the receipt.',
      ),
      'categoryHint': Schema.string(
        nullable: true,
        description: 'Vietnamese category hint such as ăn uống or mua sắm.',
      ),
      'confidence': Schema.number(minimum: 0, maximum: 1),
    },
    propertyOrdering: <String>[
      'type',
      'amount',
      'currencyCode',
      'note',
      'merchantName',
      'happenedAt',
      'categoryHint',
      'confidence',
    ],
  );

  static final Schema _transactionListSchema = Schema.object(
    properties: <String, Schema>{
      'transactions': Schema.array(
        items: _transactionSchema,
        description: 'All visible transactions parsed from the image.',
      ),
    },
    propertyOrdering: <String>['transactions'],
  );

  Future<List<OcrTransactionJson>> parseTransactions({
    required String recognizedText,
    required Uint8List imageBytes,
    required String imageMimeType,
  }) async {
    await _ensureFirebaseInitialized();

    final GenerativeModel model = FirebaseAI.googleAI().generativeModel(
      model: _model,
      systemInstruction: Content.system(_instructions),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: _transactionListSchema,
      ),
    );

    try {
      final GenerateContentResponse response = await model.generateContent(
        <Content>[
          Content.multi(<Part>[
            TextPart(
              _buildPrompt(recognizedText, hasImage: imageBytes.isNotEmpty),
            ),
            if (imageBytes.isNotEmpty)
              InlineDataPart(
                _normalizeImageMimeType(imageMimeType),
                imageBytes,
              ),
          ]),
        ],
      );
      final String? responseText = response.text;
      if (responseText == null || responseText.trim().isEmpty) {
        throw const FormatException('Firebase AI response is empty.');
      }

      final Object? decoded = jsonDecode(responseText);
      if (decoded is Map<String, dynamic>) {
        return _readTransactions(decoded);
      }
      if (decoded is List) {
        return _readTransactionList(decoded);
      }
      throw const FormatException(
        'Firebase AI response is not a JSON object or array.',
      );
    } on FirebaseAIException catch (error) {
      throw OcrTransactionAiException(_mapFirebaseAiError(error));
    }
  }

  Future<void> _ensureFirebaseInitialized() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    try {
      await Firebase.initializeApp();
    } on FirebaseException catch (error) {
      throw OcrTransactionAiException(_mapFirebaseCoreError(error));
    } on PlatformException catch (error) {
      throw OcrTransactionAiException(_mapFirebasePlatformError(error));
    }
  }

  static const String _instructions = '''
Bạn là bộ chuyển đổi ảnh hóa đơn hoặc màn hình lịch sử giao dịch sang JSON cho app quản lý chi tiêu cá nhân tại Việt Nam.
Luôn đọc ảnh được đính kèm; OCR text chỉ là dữ liệu hỗ trợ vì có thể thiếu hoặc sai.
Trả về object có key transactions là danh sách tất cả giao dịch nhìn thấy trong ảnh.
Nếu ảnh là lịch sử giao dịch, tách từng dòng giao dịch thành một item riêng, không chỉ lấy giao dịch đầu tiên.
Bỏ qua số dư ví, tab, nút, banner, ưu đãi, menu và các dòng không phải giao dịch.
Chỉ dùng thông tin có trong ảnh hoặc OCR text. Không bịa số tiền.
Với lịch sử giao dịch: dấu + là income, dấu - là expense, amount luôn là số tuyệt đối.
Với hóa đơn: ưu tiên tổng thanh toán / total / thành tiền cuối cùng làm amount.
Nếu không thấy ngày giờ, dùng ngày hiện tại trong prompt.
Nếu không chắc merchant hoặc category thì trả null.
note nên ngắn, tiếng Việt, ví dụ: "Thanh toán GALAXY CINEMA".
''';

  String _buildPrompt(String recognizedText, {required bool hasImage}) {
    return '''
Ngày hiện tại: ${DateTime.now().toIso8601String()}

OCR text:
"""
${recognizedText.isEmpty ? 'Không đọc được OCR text, hãy đọc trực tiếp từ ảnh.' : recognizedText}
"""

${hasImage ? 'Ảnh hóa đơn đã được gửi cùng request này.' : 'Không có ảnh trong request này, hãy dùng OCR text.'}
Hãy trả về đúng JSON theo schema, với transactions là danh sách giao dịch.
''';
  }

  List<OcrTransactionJson> _readTransactions(Map<String, dynamic> json) {
    final Object? value = json['transactions'];
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map(OcrTransactionJson.fromJson)
          .toList();
    }
    if (json.containsKey('amount') || json.containsKey('type')) {
      return <OcrTransactionJson>[OcrTransactionJson.fromJson(json)];
    }
    throw const FormatException('Firebase AI response has no transactions.');
  }

  List<OcrTransactionJson> _readTransactionList(List<dynamic> items) {
    return items
        .whereType<Map<String, dynamic>>()
        .map(OcrTransactionJson.fromJson)
        .toList();
  }

  String _normalizeImageMimeType(String imageMimeType) {
    final String normalized = imageMimeType.trim().toLowerCase();
    return normalized.isEmpty ? 'image/jpeg' : normalized;
  }

  String _mapFirebaseAiError(FirebaseAIException error) {
    return switch (error) {
      QuotaExceeded() =>
        'Firebase AI đã vượt quota. Hãy kiểm tra billing/quota trong Firebase hoặc Google AI Studio.',
      InvalidApiKey() =>
        'Firebase AI API key chưa hợp lệ. Hãy kiểm tra cấu hình Firebase của app.',
      ServiceApiNotEnabled() =>
        'Firebase AI Logic chưa được bật cho project. Vào Firebase Console > AI Logic và bấm Get started.',
      UnsupportedUserLocation() =>
        'Firebase AI chưa hỗ trợ khu vực tài khoản/thiết bị hiện tại.',
      ServerException(:final message) => 'Firebase AI lỗi máy chủ: $message',
      FirebaseAIException(:final message) => 'Firebase AI lỗi: $message',
    };
  }

  String _mapFirebaseCoreError(FirebaseException error) {
    final String message = error.message ?? '';
    if (error.code == 'core/no-app' ||
        error.code == 'core/not-initialized' ||
        message.contains('Firebase has not been correctly initialized')) {
      return 'Chưa cấu hình Firebase cho app. Hãy chạy flutterfire configure để tạo lib/firebase_options.dart và config iOS/Android.';
    }
    return 'Không khởi tạo được Firebase: ${message.isEmpty ? error.code : message}';
  }

  String _mapFirebasePlatformError(PlatformException error) {
    if (error.code == 'channel-error') {
      return 'Firebase native plugin chưa được nạp. Hãy stop app hoàn toàn rồi chạy flutter clean, flutter pub get và flutter run lại.';
    }
    return 'Không khởi tạo được Firebase: ${error.message ?? error.code}';
  }
}

class OcrTransactionAiException implements Exception {
  const OcrTransactionAiException(this.message);

  final String message;

  @override
  String toString() => message;
}
