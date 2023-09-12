import 'dart:io';
import 'dart:math';
import 'package:aiffelthon_hair/database/save_analysis_result.dart';
import 'package:flutter/material.dart';
import 'package:aiffelthon_hair/ui_screen/imageLoader.dart';
import 'package:aiffelthon_hair/ai/classifyer.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  File? _image;
  List<List<double>>? _predictResults; // 결과를 저장할 2차원 리스트
  bool _isLoading = false;
  List<String> scalpType = ['미세각질', '피지과다', '모낭사이홍반', '모낭홍반농포', '비듬', '탈모'];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_image != null)
            SizedBox(
              width: screenWidth,
              height: screenHeight * 0.4,
              child: Image.file(
                _image!,
                fit: BoxFit.cover,
              ),
            )
          else
            Text('No image selected.'),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final loadedImage = await loadImage();
                if (loadedImage != null) {
                  setState(() {
                    _image = loadedImage;
                    _isLoading = true;
                  });

                  final preprocessedImage = preprocessImage(_image);
                  final predictResults = [];
                  for (var i = 1; i <= 6; i++) {
                    final modelPath = 'assets/model/model$i.tflite';
                    final predictResult = await classifyPreprocessedImage(
                        modelPath, preprocessedImage);
                    predictResults.add(predictResult);
                  }

                  setState(() {
                    _predictResults = predictResults.cast<List<double>>();
                    _isLoading = false;
                  });
                  // 분석결과 저장
                  // await saveAnalysisResult(loadedImage, predictResults);
                }
              },
              child: Text('Select Image'),
            ),
          ),
          SizedBox(height: 20),
          Center(
              child: Column(
            children: [
              Text(
                'Scalp Type Result:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              if (_isLoading) ...[
                CircularProgressIndicator(
                  color: Colors.black87,
                ),
              ] else if (_predictResults != null) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text('카테고리'),
                          Text('양호:'),
                          Text('경증:'),
                          Text('중증도:'),
                          Text('중증:')
                        ],
                      ),
                      for (int i = 0; i < _predictResults!.length; i++) ...[
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Text(scalpType[i]),
                            Text('${_predictResults![i][0].toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: _predictResults![i][0] ==
                                            _predictResults![i].reduce(max)
                                        ? Colors.red
                                        : Colors.black)),
                            Text('${_predictResults![i][1].toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: _predictResults![i][1] ==
                                            _predictResults![i].reduce(max)
                                        ? Colors.red
                                        : Colors.black)),
                            Text('${_predictResults![i][2].toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: _predictResults![i][2] ==
                                            _predictResults![i].reduce(max)
                                        ? Colors.red
                                        : Colors.black)),
                            Text('${_predictResults![i][3].toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: _predictResults![i][3] ==
                                            _predictResults![i].reduce(max)
                                        ? Colors.red
                                        : Colors.black)),
                          ],
                        ),
                      ],
                    ],
                  ),
                )
              ] else ...[
                Text('분석결과없음'),
              ]
            ],
          )),
        ],
      ),
    );
  }
}


// class _AnalysisScreenState extends State<AnalysisScreen> {
//   File? _image;
//   List<double>? _predictResult;
//   bool _isLoading = false; // 추가된 상태 변수

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (_image != null)
//             SizedBox(
//               width: screenWidth,
//               height: screenHeight * 0.4,
//               child: Image.file(
//                 _image!,
//                 fit: BoxFit.cover,
//               ),
//             )
//           else
//             Text('No image selected.'),
//           SizedBox(height: 20),
//           Center(
//             child: ElevatedButton(
//               onPressed: () async {
//                 final loadedImage = await loadImage(); // 갤러리에서 이미지 불러오기
//                 if (loadedImage != null) {
//                   setState(() {
//                     _image = loadedImage;
//                     _isLoading = true; // 연산 시작 전에 _isLoading을 true로 설정
//                   });
//                   final predictResult = await classifyImage(_image);
//                   setState(() {
//                     _predictResult = predictResult;
//                     _isLoading = false; // 연산 후에 _isLoading을 false로 설정
//                   });
//                   await saveAnalysisResult(loadedImage, predictResult);
//                 }
//               },
//               child: Text('Select Image'),
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//               child: Column(
//             children: [
//               Text(
//                 'Scalp Type Result:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               if (_isLoading) ...[
//                 CircularProgressIndicator(
//                   color: Colors.black87,
//                 ), // 로딩 인디케이터 추가
//               ] else if (_predictResult != null &&
//                   _predictResult!.length == 4) ...[
//                 Text('양호: ${_predictResult![0].toStringAsFixed(2)}'),
//                 Text('경증: ${_predictResult![1].toStringAsFixed(2)}'),
//                 Text('중증도: ${_predictResult![2].toStringAsFixed(2)}'),
//                 Text('중증: ${_predictResult![3].toStringAsFixed(2)}'),
//               ] else ...[
//                 Text('분석결과없음'),
//               ]
//             ],
//           )),
//         ],
//       ),
//     );
//   }
// }
