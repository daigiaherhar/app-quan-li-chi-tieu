import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/entities/ocr_transaction_result.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/repositories/ocr_transaction_repository.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/usecases/scan_receipt_image_params.dart';

class ScanReceiptImageUseCase
    extends BaseUseCase<ScanReceiptImageParams, OcrTransactionResult> {
  ScanReceiptImageUseCase(this._repository);

  final OcrTransactionRepository _repository;

  @override
  Future<Result<OcrTransactionResult>> call(ScanReceiptImageParams params) {
    return _repository.scanImage(
      imagePath: params.imagePath,
      imageBytes: params.imageBytes,
      imageMimeType: params.imageMimeType,
    );
  }
}
