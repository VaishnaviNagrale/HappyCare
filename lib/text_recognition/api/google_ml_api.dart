import 'dart:io';
import 'package:google_ml_vision/google_ml_vision.dart';

class GoogleMLapi {
 static Future<String> recogniseText(File imageFile) async {
  if (imageFile == null) {
    return 'No image is selected';
  } else {
    final visionImage = GoogleVisionImage.fromFile(imageFile);
    final textRecognizer = GoogleVision.instance.textRecognizer();
print("hello");
    try {
      final visionText = await textRecognizer.processImage(visionImage);
      await textRecognizer.close();
      final text = extractText(visionText);
      return text.isEmpty ? 'No text found in the image' : text;
    } catch (error) {
      print('Error in text recognition: $error');
      return error.toString();
    }
  }
}

 static extractText(VisionText visionText) {
    String text = '';
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          text = '$text${word.text}';
        }
        text = '$text\n';
      }
    }
    return text;
  }
}
