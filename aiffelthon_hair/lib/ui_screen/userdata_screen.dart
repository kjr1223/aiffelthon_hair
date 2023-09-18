import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDataScreen extends StatefulWidget {
  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // ThemeProvider 상태 가져오기

    // 3. 테마 정보에 따라 Text의 스타일을 설정합니다.
    TextStyle titleStyle = themeProvider.isDarkMode
        ? TextStyle(color: Colors.white)
        : TextStyle(color: Colors.black);
    Color scaffoldBackgroundColor =
        themeProvider.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor, // 배경색을 다크모드에 따라 변경
      appBar: AppBar(
        title: Text('사용자 데이터', style: titleStyle),
        backgroundColor: themeProvider.isDarkMode
            ? Colors.black
            : Colors.blue, // 배경색을 다크모드에 따라 변경
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('데이터 내보내기', style: titleStyle),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: _exportUserData,
          ),
          ListTile(
            title: Text('데이터 삭제', style: titleStyle),
            trailing: Icon(Icons.delete),
            onTap: _deleteUserData,
          ),
        ],
      ),
    );
  }

  void _exportUserData() {
    // 예: 사용자 데이터를 CSV 파일로 변환하거나 클라우드에 저장하는 등
    print("데이터를 내보냅니다.");
    // TODO: 실제 내보내기 로직 구현
  }

  void _deleteUserData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('데이터 삭제 확인'),
        content: Text('정말로 사용자 데이터를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('삭제'),
            onPressed: () {
              // 여기에 사용자 데이터를 삭제하는 로직을 구현합니다.
              print("데이터를 삭제합니다.");
              // TODO: 실제 삭제 로직 구현

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
