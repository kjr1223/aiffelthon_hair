// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';
import 'package:aiffelthon_hair/sqlfite_database/save_analysis_result.dart';
import 'package:flutter/material.dart';
import 'package:aiffelthon_hair/ui_screen/imageLoader.dart';
import 'package:aiffelthon_hair/ai/classifyer.dart';
import 'package:aiffelthon_hair/scalp_type_analizer.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  File? _image; // 갤러리에서 불러온 이미지
  bool _isLoading = false; // 모델 연산 중 여부
  List<List<double>>? predictionsProbs; // 예측 확률 결과
  List<int>? predictedLabels; // 예측 라벨 결과(가장 높은 확률값들의 인덱스)
  String? scalpType;
  List<String> scalp_diseases = [
    '미세각질',
    '피지과다',
    '모낭사이홍반',
    '모낭홍반농포',
    '비듬',
    '탈모'
  ];
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
            // 이미지 표시 영역
            SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.3,
              child: Image.file(
                _image!,
                fit: BoxFit.cover,
              ),
            )
          else
            const Text('No image selected.'),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                // 갤러리에서 이미지를 불러오기
                final loadedImage = await loadImage();
                if (loadedImage != null) {
                  setState(() {
                    _image = loadedImage;
                    _isLoading = true;
                  });

                  // 예측 작업 수행
                  final predictResult =
                      await classifyPreprocessedImage(_image!);

                  setState(() {
                    predictionsProbs = predictResult;
                    scalpType =
                        getMostSimilarScalpType(predictionsProbs!); // 두피 유형 진단
                    _isLoading = false;
                  });
                  // 데이터베이스에 분석결과 저장
                  // await saveAnalysisResult(loadedImage, probabilities);
                }
              },
              child: const Text('두피 사진 불러오기'),
            ),
          ),
          const SizedBox(height: 20),
          Center(
              child: Column(
            children: [
              const Text(
                'Scalp Condition Result:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (_isLoading) ...[
                const CircularProgressIndicator(
                  color: Colors.black87,
                ),
              ] else if (predictionsProbs != null) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Column(
                        children: [
                          Text('카테고리'),
                          Text('양호:'),
                          Text('경증:'),
                          Text('중증도:'),
                          Text('중증:')
                        ],
                      ),
                      for (int i = 0; i < predictionsProbs!.length; i++) ...[
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Text(scalp_diseases[i]),
                            Text(
                                '${predictionsProbs![i][0].toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: predictionsProbs![i][0] ==
                                            predictionsProbs![i].reduce(max)
                                        ? Colors.red
                                        : Colors.black)),
                            Text(
                                '${predictionsProbs![i][1].toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: predictionsProbs![i][1] ==
                                            predictionsProbs![i].reduce(max)
                                        ? Colors.red
                                        : Colors.black)),
                            Text(
                                '${predictionsProbs![i][2].toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: predictionsProbs![i][2] ==
                                            predictionsProbs![i].reduce(max)
                                        ? Colors.red
                                        : Colors.black)),
                            Text(
                                '${predictionsProbs![i][3].toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: predictionsProbs![i][3] ==
                                            predictionsProbs![i].reduce(max)
                                        ? Colors.red
                                        : Colors.black)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '가장 유사한 두피 유형:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  scalpType!,
                  style: const TextStyle(fontSize: 16),
                ),
              ] else ...[
                const Text('분석결과없음'),
              ],
            ],
          )),
        ],
      ),
    );
  }
}

// 수정 전 코드
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
