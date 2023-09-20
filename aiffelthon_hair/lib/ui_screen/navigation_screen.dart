import 'package:aiffelthon_hair/ui_screen/home_screen.dart';
import 'package:aiffelthon_hair/ui_screen/analysis_screen.dart';
import 'package:aiffelthon_hair/ui_screen/history_screen.dart';
import 'package:aiffelthon_hair/ui_screen/board_screen.dart';
import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:aiffelthon_hair/ui_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  // State 객체를 생성합니다.
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

// _NavigationScreenState는 NavigationScreen의 상태를 관리합니다.
class _NavigationScreenState extends State<NavigationScreen> {
  // 현재 선택된 탭의 인덱스를 저장하는 변수입니다.
  int _selectedIndex = 0;

  // 각 탭에 대한 NavigatorState의 GlobalKey를 저장하는 리스트입니다.
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // 각 탭에 대한 Navigator 위젯을 저장하는 리스트입니다.
  late List<Widget> _widgetOptions = [
    Navigator(
        key: _navigatorKeys[0],
        onGenerateRoute: (route) =>
            MaterialPageRoute(builder: (context) => HomeScreen())),
    Navigator(
        key: _navigatorKeys[1],
        onGenerateRoute: (route) =>
            MaterialPageRoute(builder: (context) => AnalysisScreen())),
    Navigator(
        key: _navigatorKeys[2],
        onGenerateRoute: (route) =>
            MaterialPageRoute(builder: (context) => HistoryScreen())),
    Navigator(
        key: _navigatorKeys[3],
        onGenerateRoute: (route) =>
            MaterialPageRoute(builder: (context) => BoardScreen())),
    Navigator(
      key: _navigatorKeys[4],
      onGenerateRoute: (route) => MaterialPageRoute(
          builder: (context) => SettingsScreen(navContext: context)),
    )
  ];

  // 위젯의 UI를 구성합니다.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('두피새싹'),
      //   backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.blue,
      // ),
      // 현재 선택된 탭에 해당하는 화면만 표시하고 나머지는 숨깁니다.
      body: Stack(
        children: _widgetOptions.map((widget) {
          int index = _widgetOptions.indexOf(widget);
          return Offstage(
            offstage: _selectedIndex != index,
            child: widget,
          );
        }).toList(),
      ),
      // 하단의 네비게이션 바를 구성합니다.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'board',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black87,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  // 사용자가 네비게이션 바의 아이템을 탭할 때 호출되는 메서드입니다.
  void _onItemTapped(int index) {
    if (index == 2 && _selectedIndex != index) {
      // HistoryScreen의 Navigator를 새로 생성
      setState(() {
        _widgetOptions[2] = Navigator(
          key: _navigatorKeys[2],
          onGenerateRoute: (route) =>
              MaterialPageRoute(builder: (context) => HistoryScreen()),
        );
        print('HistoryScreen reload');
      });
    }

    //HistoryScreen을 벗어날 때 Navigator 스택 초기화
    if (_selectedIndex == 2 && index != 2) {
      _navigatorKeys[2].currentState?.popUntil((route) => route.isFirst);
    }

    setState(() {
      _selectedIndex = index;
    });
  }
}
