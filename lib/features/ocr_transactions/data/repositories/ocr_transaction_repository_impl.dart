import 'dart:typed_data';

import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/data/services/receipt_text_recognition_service.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/data/services/receipt_transaction_ai_parser.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/entities/ocr_transaction_result.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/repositories/ocr_transaction_repository.dart';

class OcrTransactionRepositoryImpl implements OcrTransactionRepository {
  const OcrTransactionRepositoryImpl(
    this._textRecognitionService,
    this._aiParser,
  );

  final ReceiptTextRecognitionService _textRecognitionService;
  final ReceiptTransactionAiParser _aiParser;

  @override
  Future<Result<OcrTransactionResult>> scanImage({
    required String imagePath,
    required Uint8List imageBytes,
    required String imageMimeType,
  }) async {
    try {
      final String rawText = await _textRecognitionService.recognizeImageText(
        imagePath,
      );

      if (rawText.isEmpty && imageBytes.isEmpty) {
        return const Failure<OcrTransactionResult>(
          'Không đọc được chữ trong ảnh. Thử ảnh rõ hơn nhé.',
        );
      }

      final List<OcrTransactionJson> transactions = await _aiParser
          .parseTransactions(
            recognizedText: rawText,
            imageBytes: imageBytes,
            imageMimeType: imageMimeType,
          );

      if (transactions.isEmpty) {
        return const Failure<OcrTransactionResult>(
          'Không tìm thấy giao dịch nào trong ảnh. Thử ảnh rõ hơn nhé.',
        );
      }

      return Success<OcrTransactionResult>(
        OcrTransactionResult(rawText: rawText, transactions: transactions),
      );
    } on OcrTransactionAiException catch (error) {
      return Failure<OcrTransactionResult>(error.message);
    } on FormatException {
      return const Failure<OcrTransactionResult>(
        'AI trả về dữ liệu chưa đúng định dạng. Vui lòng thử lại.',
      );
    } catch (error) {
      return Failure<OcrTransactionResult>(
        'Không thể quét giao dịch từ ảnh. $error',
      );
    }
  }
}
