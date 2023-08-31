import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _result = '';
  String _startDate = ''; // 날짜를 저장할 변수

  @override
  void initState() {
    super.initState();
    // 현재 날짜를 구해서 _startDate 변수에 저장 (년-월-일 형식)
    DateTime now = DateTime.now();
    _startDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
              '내 두피 기록',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 50,
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '날짜:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      Text(
                        _startDate,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '두피 진단 결과:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        _result,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
