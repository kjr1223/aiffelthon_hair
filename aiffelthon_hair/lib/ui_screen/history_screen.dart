import 'dart:io';

import 'package:aiffelthon_hair/database/load_analysis_result.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryItem> _historyItems = []; // 데이터베이스에서 불러온 항목을 저장할 리스트

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
  }

  void _loadHistoryData() async {
    final results = await getAnalysisResults();
    setState(() {
      _historyItems = results.map((result) {
        final result1 = double.parse(result['result_1'].toStringAsFixed(2));
        final result2 = double.parse(result['result_2'].toStringAsFixed(2));
        final result3 = double.parse(result['result_3'].toStringAsFixed(2));
        final result4 = double.parse(result['result_4'].toStringAsFixed(2));

        return HistoryItem(
          imagePath: result['image_path'],
          result: '양호: $result1 경증: $result2 중증도: $result3 중증: $result4',
          analysisDate: result['analysis_date'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _historyItems.length,
      itemBuilder: (context, index) {
        final historyItem = _historyItems[index];
        return HistoryListItem(
          imagePath: historyItem.imagePath,
          result: historyItem.result,
          analysisDate: historyItem.analysisDate,
        );
      },
    );
  }
}

class HistoryItem {
  final String imagePath;
  final String result;
  final String analysisDate;

  HistoryItem({
    required this.imagePath,
    required this.result,
    required this.analysisDate,
  });
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
    return ListTile(
      leading: Image.file(
        File(imagePath),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text('날짜: $analysisDate'),
      subtitle: Text('두피 진단 결과: $result'),
    );
  }
}
