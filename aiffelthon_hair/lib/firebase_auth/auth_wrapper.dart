import 'package:aiffelthon_hair/ui_screen/login_screen.dart';
import 'package:aiffelthon_hair/ui_screen/navigation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Firebase 초기화 및 인증 상태 확인을 기다리는 동안 로딩 화면 표시
          return LoadingScreen();
        } else if (snapshot.hasError) {
          // 오류가 발생한 경우 오류 화면 표시
          return ErrorScreen();
        } else {
          final User? user = snapshot.data;
          if (user == null) {
            // 사용자가 로그아웃 상태일 경우 로그인 화면으로 이동
            print('(authentication) 로그인 화면으로 이동');
            return LoginScreen();
          } else {
            // 사용자가 로그인 상태일 경우 메인 화면으로 이동
            print('(authentication) 메인화면으로 이동');
            return NavigationScreen();
          }
        }
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // 로딩 인디케이터 표시
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('오류가 발생했습니다.'),
      ),
    );
  }
}
