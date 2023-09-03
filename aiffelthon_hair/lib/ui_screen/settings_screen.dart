import 'package:firebase_auth/firebase_auth.dart';
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
            await GoogleSignIn().signOut(); // Google 로그인 세션 종료
            await FirebaseAuth.instance.signOut(); // firebase 인증 세션 종료

            print(
                'user instance : ${FirebaseAuth.instance.currentUser}'); // user 정보 확인
            print("(로그아웃 버튼) 구글 계정 로그아웃");

            // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (context) => LoginScreen()),
            //     (route) => false);
          },
        ),
      ],
    ));
  }
}
