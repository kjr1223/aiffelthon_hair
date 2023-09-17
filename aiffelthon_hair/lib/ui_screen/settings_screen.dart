import 'package:aiffelthon_hair/ui_screen/account_management_screen.dart.dart';
import 'package:aiffelthon_hair/ui_screen/themedisplay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'notification_screen.dart';
// import 'package:account_management_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  _handleLogout() async {
    await _googleSignIn.signOut(); // Google 로그인 세션 종료
    await FirebaseAuth.instance.signOut(); // firebase 인증 세션 종료

    print('user instance : ${FirebaseAuth.instance.currentUser}');
    print("(로그아웃 버튼) 구글 계정 로그아웃");
    // Optionally, you can redirect user to the login page or any other page after logout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('환경설정'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('계정관리'),
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
            title: Text('알림설정'),
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
            title: Text('테마 및 디스플레이'),
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
            title: Text('사용자 데이터'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to User Data screen
            },
          ),
          ListTile(
            title: Text('공지사항'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Announcements screen
            },
          ),
          ListTile(
            title: Text('앱 정보 및 도움말'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to App Info & Help screen
            },
          ),
          ListTile(
            title: Text('결제 및 구독'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Payments & Subscriptions screen
            },
          ),
          ListTile(
            title: Text('앱 설정 초기화'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Code to reset app settings to default
            },
          ),
          ListTile(
            title: Text('로그아웃'),
            trailing: Icon(Icons.exit_to_app),
            onTap: _handleLogout,
          )
        ],
      ),
    );
  }
}


  
// void main() => runApp(MaterialApp(home: SettingsScreen()));