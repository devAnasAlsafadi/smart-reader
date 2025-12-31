// import 'dart:io';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
//
// class OcrService {
//
//
//   late final TextRecognizer _textRecognizer;
//
//   OcrService() {
//     _textRecognizer = TextRecognizer(
//       script: TextRecognitionScript.latin
//     );
//   }
//
//
//   Future<String> extractTextFromImage(File imageFile)async {
//
//     try{
//       final InputImage inputImage = InputImage.fromFile(imageFile);
//       final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
//       // return recognizedText.text.replaceAll(RegExp(r'[^0-9]'), '');
//       print("recognizedText is  : ${recognizedText.text}");
//       return recognizedText.text;
//     }catch (e){
//       print("OCR error: $e");
//       return "";
//     }
//   }
//
//
//
//   void dispose() {
//     _textRecognizer.close();
//   }
//
// }