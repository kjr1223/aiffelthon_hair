import 'package:flutter/material.dart';

class BoardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BoardState();
  }
}

class _BoardState extends State<BoardScreen> {
  @override
  Widget build(Object context) {
    return Scaffold(
      body: Text("게시판"),
    );
  }
}
