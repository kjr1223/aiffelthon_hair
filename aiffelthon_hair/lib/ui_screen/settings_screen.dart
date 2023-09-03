import 'package:aiffelthon_hair/login.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text('설정화면'),
        ElevatedButton(
          child: Text("로그아웃"),
          onPressed: () async {
            await GoogleSignIn().signOut();
            print("User signed out of Google account");
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
          },
        ),
      ],
    ));
  }
}
