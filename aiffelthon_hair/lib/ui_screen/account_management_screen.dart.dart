import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AccountManagementScreen extends StatefulWidget {
  @override
  _AccountManagementScreenState createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  _changeName(String name) async {
    await user!.updateDisplayName(name);
    setState(() {
      user = _auth.currentUser;
    });
  }

  _changeEmail(String email) async {
    await user!.updateEmail(email);
    setState(() {
      user = _auth.currentUser;
    });
  }

  _changePassword(String password) async {
    await user!.updatePassword(password);
  }

  _deleteAccount() async {
    if (user != null) {
      await user!.delete();
    } else {
      print("Error: No user found");
    }
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
      appBar: AppBar(
        title: Text('게시판', style: titleStyle),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.green,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('프로필 사진 변경'),
            onTap: () {
              // Code to change profile picture
            },
          ),
          ListTile(
            title: Text('이름 변경: ${user?.displayName ?? '이름없음'}'),
            onTap: () async {
              String? newName =
                  await _showInputTextDialog(context, '새로운 이름을 입력해주세요.');
              if (newName != null) {
                _changeName(newName);
              }
            },
          ),
          ListTile(
            title: Text('이메일 변경: ${user?.email ?? '이메일 없음'}'),
            onTap: () async {
              String? newEmail =
                  await _showInputTextDialog(context, '새로운 이메일을 입력해주세요.');
              if (newEmail != null) {
                _changeEmail(newEmail);
              }
            },
          ),
          ListTile(
            title: Text('비밀번호 변경'),
            onTap: () async {
              String? newPassword =
                  await _showInputTextDialog(context, '새로운 비밀번호를 입력해주세요.');
              if (newPassword != null) {
                _changePassword(newPassword);
              }
            },
          ),
          ListTile(
            title: Text('계정 삭제'),
            onTap: _deleteAccount,
          ),
        ],
      ),
    );
  }

  Future<String?> _showInputTextDialog(
      BuildContext context, String hint) async {
    String? inputText;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(hint),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(inputText);
              },
            ),
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
          ],
        );
      },
    );
  }
}
