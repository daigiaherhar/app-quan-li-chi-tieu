import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptTextRecognitionService {
  Future<String> recognizeImageText(String imagePath) async {
    final TextRecognizer textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    try {
      final InputImage inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      return recognizedText.text.trim();
    } finally {
      await textRecognizer.close();
    }
  }
}
