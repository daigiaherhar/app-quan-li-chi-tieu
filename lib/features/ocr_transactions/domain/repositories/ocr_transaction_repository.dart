import 'dart:typed_data';

import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/entities/ocr_transaction_result.dart';

abstract class OcrTransactionRepository {
  Future<Result<OcrTransactionResult>> scanImage({
    required String imagePath,
    required Uint8List imageBytes,
    required String imageMimeType,
  });
}
