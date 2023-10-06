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
        ? TextStyle(color: Colors.white, fontFamily: 'DoHyeonRegular')
        : TextStyle(color: Colors.black, fontFamily: 'DoHyeonRegular');
    Color scaffoldBackgroundColor =
        themeProvider.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '계정관리',
          style: TextStyle(fontFamily: 'DoHyeonRegular', color: Colors.green),
        ),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // 뒤로 가기 아이콘
            color: Colors.green, // 아이콘 색상 설정
          ),
          onPressed: () {
            // 뒤로 가기 버튼 눌렀을 때 동작 설정
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('프로필 사진 변경', style: titleStyle),
            onTap: () {
              // Code to change profile picture
            },
          ),
          ListTile(
            title: Text('이름 변경: ${user?.displayName ?? '이름없음'}',
                style: titleStyle),
            onTap: () async {
              String? newName =
                  await _showInputTextDialog(context, '새로운 이름을 입력해주세요.');
              if (newName != null) {
                _changeName(newName);
              }
            },
          ),
          ListTile(
            title:
                Text('이메일 변경: ${user?.email ?? '이메일 없음'}', style: titleStyle),
            onTap: () async {
              String? newEmail =
                  await _showInputTextDialog(context, '새로운 이메일을 입력해주세요.');
              if (newEmail != null) {
                _changeEmail(newEmail);
              }
            },
          ),
          ListTile(
            title: Text('비밀번호 변경', style: titleStyle),
            onTap: () async {
              String? newPassword =
                  await _showInputTextDialog(context, '새로운 비밀번호를 입력해주세요.');
              if (newPassword != null) {
                _changePassword(newPassword);
              }
            },
          ),
          ListTile(
            title: Text('계정 삭제', style: titleStyle),
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
              child: Text('확인', style: TextStyle(fontFamily: 'DoHyeonRegular')),
              onPressed: () {
                Navigator.of(context).pop(inputText);
              },
            ),
            TextButton(
              child: Text('취소', style: TextStyle(fontFamily: 'DoHyeonRegular')),
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
