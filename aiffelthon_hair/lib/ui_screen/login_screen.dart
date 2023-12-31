import 'package:aiffelthon_hair/firebase_auth/auth_service.dart';
import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String _title = 'App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const LoginStatefulWidget(),
      ),
    );
  }
}

class LoginStatefulWidget extends StatefulWidget {
  const LoginStatefulWidget({Key? key}) : super(key: key);

  @override
  State<LoginStatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
              '두피 유형 검사',
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white70
                        : Colors.black,
                  )),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              //forgot password screen
            },
            child: const Text('Forgot Password'),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                print(nameController.text);
                print(passwordController.text);
              },
            ),
          ),
          Row(
            children: <Widget>[
              const Text('Does not have account?'),
              TextButton(
                child: const Text('Sign in', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()));
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SignInButton(Buttons.Google, onPressed: () async {
            try {
              UserCredential userCredential = await signInWithGoogle();
              print('User ID: ${userCredential.user?.uid}');
              // 로그인 성공 시 Navigation_screen으로 이동
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => NavigationScreen()));
            } catch (error) {
              print('Error: $error');
              // 에러 처리를 추가합니다.
            }
          })
        ],
      ),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Registration Screen")),
        body: Center(
            child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                  decoration: InputDecoration(hintText: "Enter your email"))),
          Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                  decoration:
                      InputDecoration(hintText: "Enter your password"))),
          Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(onPressed: () {}, child: Text("Register")))
        ])));
  }
}
