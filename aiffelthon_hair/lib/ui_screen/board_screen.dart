import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BoardState();
}

class _BoardState extends State<BoardScreen> {
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
        title: Text('게시판', style: titleStyle),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.blue,
      ),
    );
  }
}
