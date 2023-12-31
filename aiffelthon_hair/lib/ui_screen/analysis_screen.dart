import 'dart:io';
import 'dart:math';
import 'package:aiffelthon_hair/sqlfite_database/analysis_result_model.dart';
import 'package:aiffelthon_hair/sqlfite_database/save_analysis_result.dart';
import 'package:aiffelthon_hair/ui_screen/microscope_widget.dart';
import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:aiffelthon_hair/ui_screen/imageLoader.dart';
import 'package:aiffelthon_hair/ai/classifyer.dart';
import 'package:aiffelthon_hair/scalp_type_analizer.dart';
import 'package:provider/provider.dart';
// import 'package:aiffelthon_hair/flutter_usb_camera/example/lib/microscope_widget.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  File? _image;
  bool _isLoading = false;
  List<List<double>>? predictionsProbs;
  List<int>? predictedLabels;
  String scalpType = '';
  List<String> scalpDiseases = [
    '미세각질',
    '피지과다',
    '모낭사이홍반',
    '모낭홍반농포',
    '비듬',
    '탈모',
  ];

  Future<void> processAndDisplayImage(File image) async {
    setState(() {
      _image = image;
      _isLoading = true;
    });

    final predictResult = await classifyPreprocessedImage(_image!);

    setState(() {
      predictionsProbs = predictResult;
      scalpType = getMostSimilarScalpType(predictionsProbs!);
      _isLoading = false;
    });

    List<int> predictedLabels = predictionsProbs!
        .map((row) =>
            row.indexOf(row.reduce((curr, next) => curr > next ? curr : next)))
        .toList();

    List<String> scalpStage = ['양호', '경증', '중증도', '중증'];
    AnalysisResult analysisResult = AnalysisResult(
      imagePath: _image!.path,
      analysisDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      scalpType: scalpType,
      result1: scalpStage[predictedLabels[0]],
      result2: scalpStage[predictedLabels[1]],
      result3: scalpStage[predictedLabels[2]],
      result4: scalpStage[predictedLabels[3]],
      result5: scalpStage[predictedLabels[4]],
      result6: scalpStage[predictedLabels[5]],
    );
    await saveAnalysisResult(analysisResult);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextStyle titleStyle = themeProvider.isDarkMode
        ? TextStyle(color: Colors.white, fontFamily: 'DoHyeonRegular')
        : TextStyle(color: Colors.black, fontFamily: 'DoHyeonRegular');
    Color scaffoldBackgroundColor =
        themeProvider.isDarkMode ? Colors.black : Colors.white;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '결과',
          style: TextStyle(
            fontFamily: 'DoHyeonRegular',
            color: Colors.green,
          ),
        ),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_image != null)
                Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.3,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(child: Text('No image selected.'))),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MicroscopeWidget(),
                      ),
                    );

                    if (result != null && result is File) {
                      await processAndDisplayImage(result);
                    }
                  },
                  child: Text(
                    "두피 사진 촬영하기",
                    style: TextStyle(
                      fontFamily: 'DoHyeonRegular',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () async {
                    final loadedImage = await loadImage();
                    if (loadedImage != null) {
                      await processAndDisplayImage(loadedImage);
                    }
                  },
                  child: const Text('두피 사진 불러오기',
                      style: TextStyle(fontFamily: 'DoHyeonRegular')),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Scalp Condition Result:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const CircularProgressIndicator(
                        color: Colors.black87,
                      )
                    else if (predictionsProbs != null)
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
                                Text('중증:'),
                              ],
                            ),
                            for (int i = 0;
                                i < predictionsProbs!.length;
                                i++) ...[
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(scalpDiseases[i]),
                                  Text(
                                    '${predictionsProbs![i][0].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: predictionsProbs![i][0] ==
                                              predictionsProbs![i].reduce(max)
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${predictionsProbs![i][1].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: predictionsProbs![i][1] ==
                                              predictionsProbs![i].reduce(max)
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${predictionsProbs![i][2].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: predictionsProbs![i][2] ==
                                              predictionsProbs![i].reduce(max)
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${predictionsProbs![i][3].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: predictionsProbs![i][3] ==
                                              predictionsProbs![i].reduce(max)
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      '가장 유사한 두피 유형:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      scalpType,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    if (predictionsProbs == null) const Text('분석결과없음'),
                  ],
                ),
              ),
            ],
          ),
        ),
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
