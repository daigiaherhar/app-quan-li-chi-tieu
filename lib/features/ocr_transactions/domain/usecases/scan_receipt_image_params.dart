import 'dart:typed_data';

class ScanReceiptImageParams {
  const ScanReceiptImageParams({
    required this.imagePath,
    required this.imageBytes,
    required this.imageMimeType,
  });

  final String imagePath;
  final Uint8List imageBytes;
  final String imageMimeType;
}
