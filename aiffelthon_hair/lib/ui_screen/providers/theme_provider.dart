import 'package:flutter/material.dart';

// ChangeNotifier를 상속받는 ThemeProvider 클래스. 이 클래스는 앱의 테마와 관련된 상태를 관리합니다.
class ThemeProvider with ChangeNotifier {
  // 어두운 모드가 활성화되어 있는지를 나타내는 부울 값. 초기 값은 false입니다.
  bool _isDarkMode = false;

  // 사용자가 선택한 폰트 크기를 저장하는 변수. 초기 값은 14입니다.
  double _fontSize = 14;

  // 사용자가 선택한 배경색을 저장하는 변수. 초기 값은 흰색입니다.
  Color _backgroundColor = Colors.white;

  // 어두운 모드가 활성화되어 있으면, isDarkMode는 true 값을 반환하고 그렇지 않으면 false 값을 반환합니다.
  bool get isDarkMode => _isDarkMode;

  // 현재 설정된 폰트 크기를 반환합니다.
  double get fontSize => _fontSize;

  ThemeData get themeData => _isDarkMode ? darkTheme : lightTheme;

  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontSize: 14, // 기본 폰트 크기를 여기에 설정
        color: Colors.black, // 기본 텍스트 색상을 여기에 설정
        fontFamily: 'DoHyeonRegular', // 원하는 폰트 이름
      ),
      // 다른 텍스트 스타일도 필요한 경우 여기에 추가
    ),
    scaffoldBackgroundColor: Colors.white, // 기본 배경색을 여기에 설정
  );

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontSize: 14, // 기본 폰트 크기를 여기에 설정
        color: Colors.white, // 기본 텍스트 색상을 여기에 설정
        fontFamily: 'DoHyeonRegular', // 원하는 폰트 이름
      ),
      // 다른 텍스트 스타일도 필요한 경우 여기에 추가
    ),
    scaffoldBackgroundColor: Colors.black, // 어두운 모드의 기본 배경색을 여기에 설정
  );

  // 어두운 모드의 활성화 상태를 전환하는 메서드.
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    // 상태 변경을 알리므로써 위젯트리의 관련 부분이 재빌드됩니다.
    notifyListeners();
  }

  // 폰트 크기를 설정하는 메서드.
  void setFontSize(double fontSize) {
    _fontSize = fontSize;
    // 상태 변경을 알리므로써 위젯트리의 관련 부분이 재빌드됩니다.
    notifyListeners();
  }

  Color get backgroundColor => _backgroundColor;
  // 배경색을 설정하는 메서드.
  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    // 상태 변경을 알리므로써 위젯트리의 관련 부분이 재빌드됩니다.
    notifyListeners();
  }
}
