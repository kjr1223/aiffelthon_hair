import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _result = '';
  String _startDate = '';

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now().toString().substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
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
            child: ListView(
              children: List.generate(
                20, // 임의의 아이템 개수
                (index) => ListTile(
                  title: Text('항목 $index'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HistoryScreen(),
  ));
}
