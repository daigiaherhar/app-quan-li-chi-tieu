import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/data/repositories/ocr_transaction_repository_impl.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/data/services/receipt_text_recognition_service.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/data/services/receipt_transaction_ai_parser.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/repositories/ocr_transaction_repository.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/usecases/scan_receipt_image_usecase.dart';

final Provider<ReceiptTextRecognitionService>
receiptTextRecognitionServiceProvider = Provider<ReceiptTextRecognitionService>(
  (Ref ref) {
    return ReceiptTextRecognitionService();
  },
);

final Provider<ReceiptTransactionAiParser> receiptTransactionAiParserProvider =
    Provider<ReceiptTransactionAiParser>((Ref ref) {
      return ReceiptTransactionAiParser();
    });

final Provider<OcrTransactionRepository> ocrTransactionRepositoryProvider =
    Provider<OcrTransactionRepository>((Ref ref) {
      return OcrTransactionRepositoryImpl(
        ref.watch(receiptTextRecognitionServiceProvider),
        ref.watch(receiptTransactionAiParserProvider),
      );
    });

final Provider<ScanReceiptImageUseCase> scanReceiptImageUseCaseProvider =
    Provider<ScanReceiptImageUseCase>((Ref ref) {
      return ScanReceiptImageUseCase(
        ref.watch(ocrTransactionRepositoryProvider),
      );
    });
