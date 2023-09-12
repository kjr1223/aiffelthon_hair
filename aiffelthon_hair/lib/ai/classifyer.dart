import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

// 이미지 전처리 함수
Float32List preprocessImage(File? imageFile) {
  final image = img.decodeImage(imageFile!.readAsBytesSync());
  final resizedImage = img.copyResize(image!, width: 224, height: 224);

  final inputImageData = Float32List(1 * 224 * 224 * 3);
  var buffer = inputImageData.buffer;
  var inputImageAs4DList = buffer.asFloat32List();

  for (var y = 0; y < 224; y++) {
    for (var x = 0; x < 224; x++) {
      final pixel = resizedImage.getPixel(x, y);
      final baseIdx = (y * 224 + x) * 3;
      inputImageAs4DList[baseIdx + 0] = pixel.r.toDouble();
      inputImageAs4DList[baseIdx + 1] = pixel.g.toDouble();
      inputImageAs4DList[baseIdx + 2] = pixel.b.toDouble();
    }
  }
  return inputImageAs4DList;
}

// 이미지 분류 함수
Future<List<double>> classifyPreprocessedImage(
    String modelPath, Float32List preprocessedImage) async {
  await Future.delayed(Duration(seconds: 3)); // 2초 딜레이 추가
  Interpreter? interpreter;

  try {
    // 모델 로드
    interpreter = await Interpreter.fromAsset(modelPath);
    print('모델의 입력 모양: ${interpreter.getInputTensors()[0].shape}');
    print('모델의 출력 모양: ${interpreter.getOutputTensors()[0].shape}');

    final inputShape = interpreter.getInputTensors()[0].shape;
    final outputShape = interpreter.getOutputTensors()[0].shape;
    final outputLength =
        outputShape.reduce((value, element) => value * element);
    final outputs = List<double>.filled(outputLength, 0).reshape(outputShape);

    // 모델 실행
    interpreter.run(preprocessedImage.reshape(inputShape), outputs);
    print(outputs[0]);
    return outputs[0];
  } finally {
    // Interpreter 종료
    if (interpreter != null) {
      interpreter.close();
    }
  }
}

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;

// Future<List<double>> classifyImage(File? imageFile) async {
//   await Future.delayed(Duration(seconds: 2)); // 2초 딜레이 추가
//   Interpreter? interpreter;

//   try {
//     // 모델 로드
//     interpreter =
//         await Interpreter.fromAsset('assets/model/quantized_model.tflite');
//     print('모델의 입력 모양: ${interpreter.getInputTensors()[0].shape}');
//     print('모델의 출력 모양: ${interpreter.getOutputTensors()[0].shape}');

//     // 이미지 로드 및 전처리
//     final image = img.decodeImage(imageFile!.readAsBytesSync());
//     final resizedImage = img.copyResize(image!, width: 224, height: 224);

//     // 4차원 배열로 변환
//     final inputImageData = Float32List(1 * 224 * 224 * 3);
//     var buffer = inputImageData.buffer;

//     // 픽셀 할당
//     var inputImageAs4DList = buffer.asFloat32List();
//     for (var y = 0; y < 224; y++) {
//       for (var x = 0; x < 224; x++) {
//         final pixel = resizedImage.getPixel(x, y);
//         final baseIdx = (y * 224 + x) * 3;
//         inputImageAs4DList[baseIdx + 0] = pixel.r.toDouble();
//         inputImageAs4DList[baseIdx + 1] = pixel.g.toDouble();
//         inputImageAs4DList[baseIdx + 2] = pixel.b.toDouble();
//       }
//     }

//     // 원본 모델이 정규화 안되있음.
//     // 그래서 양자화 모델도 안함.
//     // for (var y = 0; y < height; y++) {
//     //   for (var x = 0; x < width; x++) {
//     //     final pixel = resizedImage.getPixel(x, y);
//     //     final baseIdx = (y * width + x) * channels;
//     //     inputImageAs4DList[baseIdx + 0] = pixel.r / 255.0;
//     //     inputImageAs4DList[baseIdx + 1] = pixel.g / 255.0;
//     //     inputImageAs4DList[baseIdx + 2] = pixel.b / 255.0;
//     //   }
//     // }

//     // 입력이미지 shape [1,224,224,3]
//     final inputShape = interpreter.getInputTensors()[0].shape;

//     // 출력 결과 [1,4]
//     final outputShape = interpreter.getOutputTensors()[0].shape;
//     final outputLength =
//         outputShape.reduce((value, element) => value * element);
//     final outputs = List<double>.filled(outputLength, 0).reshape(outputShape);

//     // 모델 실행
//     interpreter.run(inputImageAs4DList.reshape(inputShape), outputs);
//     print(outputs[0]);
//     return outputs[0];
//   } finally {
//     // Interpreter 종료
//     if (interpreter != null) {
//       interpreter.close();
//     }
//   }
// }
