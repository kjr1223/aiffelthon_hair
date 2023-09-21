import 'package:aiffelthon_hair/ui_screen/account_management_screen.dart.dart';
import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:aiffelthon_hair/ui_screen/themedisplay.dart';
import 'package:aiffelthon_hair/ui_screen/userdata_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'notification_screen.dart';
// import 'package:account_management_screen.dart';

class SettingsScreen extends StatefulWidget {
  final BuildContext navContext;

  SettingsScreen({required this.navContext});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _resetSettingsToDefault() {
    print("설정이 초기화되었습니다.");
  }

  void _showResetSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('설정 초기화'),
          content: Text('모든 설정을 기본값으로 복원하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                _resetSettingsToDefault();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _handleLogout() async {
    await _googleSignIn.signOut(); // Google 로그인 세션 종료
    await FirebaseAuth.instance.signOut(); // firebase 인증 세션 종료

    print('user instance : ${FirebaseAuth.instance.currentUser}');
    print("(로그아웃 버튼) 구글 계정 로그아웃");
    // Optionally, you can redirect user to the login page or any other page after logout
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // 테마 정보에 따라 Text의 스타일을 설정합니다.
    TextStyle titleStyle = themeProvider.isDarkMode
        ? TextStyle(color: Colors.white)
        : TextStyle(color: Colors.black);
    Color scaffoldBackgroundColor =
        themeProvider.isDarkMode ? Colors.black : Colors.white;
    // Color? tileColor =
    //     themeProvider.isDarkMode ? Colors.grey[900] : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor, // 배경색을 다크모드에 따라 변경
      appBar: AppBar(
        title: Text('환경설정', style: titleStyle),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.green,
      ),
      body: ListView(
        children: [
          ListTile(
            // tileColor: tileColor, // ListTile 배경색을 다크모드에 따라 변경
            title: Text('계정관리', style: titleStyle),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountManagementScreen()),
              );
              // Navigate to Account Management screen
            },
          ),
          ListTile(
            title: Text('알림설정', style: titleStyle),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationSettingsScreen()),
              );
              // Navigate to Notification Settings screen
            },
          ),
          ListTile(
            title: Text('테마 및 디스플레이', style: titleStyle),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThemeDisplayScreen(),
                ),
              );
              // Navigate to Theme & Display screen
            },
          ),
          ListTile(
            title: Text('사용자 데이터', style: titleStyle),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDataScreen(),
                ),
              );
              // Navigate to Theme & Display screen
            },
          ),
          ListTile(
            title: Text('공지사항', style: titleStyle),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  final themeProvider = Provider.of<ThemeProvider>(context);
                  Color scaffoldBackgroundColor =
                      themeProvider.isDarkMode ? Colors.black : Colors.white;
                  TextStyle titleStyle = themeProvider.isDarkMode
                      ? TextStyle(color: Colors.white)
                      : TextStyle(color: Colors.black);
                  return Scaffold(
                    backgroundColor: scaffoldBackgroundColor,
                    appBar: AppBar(
                      title: Text('공지사항', style: titleStyle),
                      backgroundColor: themeProvider.isDarkMode
                          ? Colors.black
                          : Colors.green,
                    ),
                    body: ListView(
                      children: [
                        ListTile(title: Text('3.10.0 앱 버전 업데이트')),
                        ListTile(title: Text('서비스 점검 안내')),
                        ListTile(title: Text('이용약관 개정 사전 안내')),
                      ],
                    ),
                  );
                },
              ));
            },
          ),
          ListTile(
            title: Text('앱 정보 및 도움말', style: titleStyle),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  final themeProvider = Provider.of<ThemeProvider>(context);
                  Color scaffoldBackgroundColor =
                      themeProvider.isDarkMode ? Colors.black : Colors.white;
                  TextStyle titleStyle = themeProvider.isDarkMode
                      ? TextStyle(color: Colors.white)
                      : TextStyle(color: Colors.black);
                  return Scaffold(
                    backgroundColor: scaffoldBackgroundColor,
                    appBar: AppBar(
                      title: Text('앱 정보 및 도움말', style: titleStyle),
                      backgroundColor: themeProvider.isDarkMode
                          ? Colors.black
                          : Colors.green,
                    ),
                    body: ListView(
                      children: [
                        ListTile(title: Text('앱 버전 정보')),
                        ListTile(title: Text('FAQ (자주 묻는 질문)')),
                        ListTile(title: Text('고객 지원 연결')),
                        ListTile(title: Text('사용자 메뉴얼 및 튜토리얼')),
                      ],
                    ),
                  );
                },
              ));
            },
          ),
          ListTile(
            title: Text('결제 및 구독', style: titleStyle),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  final themeProvider = Provider.of<ThemeProvider>(context);
                  Color scaffoldBackgroundColor =
                      themeProvider.isDarkMode ? Colors.black : Colors.white;
                  TextStyle titleStyle = themeProvider.isDarkMode
                      ? TextStyle(color: Colors.white)
                      : TextStyle(color: Colors.black);
                  return Scaffold(
                    backgroundColor: scaffoldBackgroundColor,
                    appBar: AppBar(
                      title: Text('결제 및 구독', style: titleStyle),
                      backgroundColor: themeProvider.isDarkMode
                          ? Colors.black
                          : Colors.green,
                    ),
                    body: ListView(
                      children: [
                        ListTile(title: Text('결제 방식 관리')),
                        ListTile(title: Text('구독 현황 및 변경')),
                        ListTile(title: Text('구매 내역')),
                      ],
                    ),
                  );
                },
              ));
            },
          ),
          ListTile(
            title: Text('앱 설정 초기화', style: titleStyle),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: _showResetSettingsDialog,
            // Code to reset app settings to default
          ),
          ListTile(
            title: Text('로그아웃', style: titleStyle),
            trailing: Icon(Icons.exit_to_app),
            onTap: _handleLogout,
          )
        ],
      ),
    );
  }
}
