import 'dart:io';
import 'package:aiffelthon_hair/sqlfite_database/load_analysis_result.dart';
import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  List<HistoryItem> _historyItems = []; // 데이터베이스에서 불러온 항목을 저장할 리스트

  // @override
  // void initState() {
  //   super.initState();
  //   loadHistoryData();
  // }

  // void loadHistoryData() async {
  //   final results = await getAnalysisResults();
  //   setState(() {
  //     _historyItems = results
  //         .map((result) => HistoryItem(
  //               imagePath: result['image_path'],
  //               analysisDate: result['analysis_date'],
  //               scalpType: result['scalp_type'].toString(),
  //               result1: result['result_1'].toString(),
  //               result2: result['result_2'].toString(),
  //               result3: result['result_3'].toString(),
  //               result4: result['result_4'].toString(),
  //               result5: result['result_5'].toString(),
  //               result6: result['result_6'].toString(),
  //             ))
  //         .toList();
  //   });
  // }
  Future<List<HistoryItem>> loadHistoryData() async {
    final results = await getAnalysisResults();
    return results
        .map((result) => HistoryItem(
              imagePath: result['image_path'],
              analysisDate: result['analysis_date'],
              scalpType: result['scalp_type'].toString(),
              result1: result['result_1'].toString(),
              result2: result['result_2'].toString(),
              result3: result['result_3'].toString(),
              result4: result['result_4'].toString(),
              result5: result['result_5'].toString(),
              result6: result['result_6'].toString(),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // ThemeProvider 상태 가져오기

    // 테마 정보에 따라 Text의 스타일을 설정합니다.
    TextStyle titleStyle = themeProvider.isDarkMode
        ? TextStyle(color: Colors.white)
        : TextStyle(color: Colors.black);
    Color scaffoldBackgroundColor =
        themeProvider.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
        backgroundColor: scaffoldBackgroundColor, // 배경색을 다크모드에 따라 변경
        appBar: AppBar(
          title: Text('기록', style: titleStyle),
          backgroundColor:
              themeProvider.isDarkMode ? Colors.black : Colors.blue,
        ),
        body: FutureBuilder<List<HistoryItem>>(
          future: loadHistoryData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _historyItems = snapshot.data ?? [];
              return ListView.builder(
                itemCount: _historyItems.length,
                itemBuilder: (context, index) {
                  final historyItem = _historyItems[index];
                  return HistoryListItem(
                    imagePath: historyItem.imagePath,
                    result: historyItem.formattedResult,
                    analysisDate: historyItem.analysisDate,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading data"));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

class HistoryItem {
  final String imagePath;
  final String analysisDate;
  final String scalpType;
  final String result1;
  final String result2;
  final String result3;
  final String result4;
  final String result5;
  final String result6;

  HistoryItem({
    required this.imagePath,
    required this.analysisDate,
    required this.scalpType,
    required this.result1,
    required this.result2,
    required this.result3,
    required this.result4,
    required this.result5,
    required this.result6,
  });

  String get formattedResult {
    return '두피유형: $scalpType, '
        '미세각질: $result1, '
        '피지과다: $result2, '
        '모낭사이홍반: $result3, '
        '모낭홍반농포: $result4, '
        '비듬: $result5, '
        '탈모: $result6';
  }
}

class HistoryListItem extends StatelessWidget {
  final String imagePath;
  final String result;
  final String analysisDate;

  HistoryListItem({
    required this.imagePath,
    required this.result,
    required this.analysisDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.file(
                  File(imagePath),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '날짜: $analysisDate',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('두피 진단 결과:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text(result, style: TextStyle(fontSize: 14)),
            // 여기에 필요한 경우 추가적인 아이콘, 버튼 등의 요소를 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}
