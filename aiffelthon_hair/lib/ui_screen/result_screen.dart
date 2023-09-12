import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String resultText;

  ResultScreen({required this.resultText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("문진 결과"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          resultText,
          style: TextStyle(fontSize: 15.0), // 원하는 글씨 크기로 설정합니다.
        ),
      ),
    );
  }
}
