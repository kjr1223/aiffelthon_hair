import 'package:aiffelthon_hair/ui_screen/home_screen.dart' hide ThemeProvider;
import 'package:aiffelthon_hair/ui_screen/analysis_screen.dart';
import 'package:aiffelthon_hair/ui_screen/history_screen.dart';
import 'package:aiffelthon_hair/ui_screen/board_screen.dart';
import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:aiffelthon_hair/ui_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  final Function(int) onSwitchTab;

  const NavigationScreen({Key? key, required this.onSwitchTab})
      : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    5,
    (index) => GlobalKey<NavigatorState>(),
  );

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = [
      Navigator(
        key: _navigatorKeys[0],
        onGenerateRoute: (route) => MaterialPageRoute(
            builder: (context) => HomeScreen(onSwitchTab: widget.onSwitchTab)),
      ),
      Navigator(
        key: _navigatorKeys[1],
        onGenerateRoute: (route) =>
            MaterialPageRoute(builder: (context) => AnalysisScreen()),
      ),
      Navigator(
        key: _navigatorKeys[2],
        onGenerateRoute: (route) =>
            MaterialPageRoute(builder: (context) => HistoryScreen()),
      ),
      Navigator(
        key: _navigatorKeys[3],
        onGenerateRoute: (route) =>
            MaterialPageRoute(builder: (context) => BoardScreen()),
      ),
      Navigator(
        key: _navigatorKeys[4],
        onGenerateRoute: (route) => MaterialPageRoute(
            builder: (context) => SettingsScreen(navContext: context)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
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
        selectedItemColor: Color.fromARGB(255, 65, 150, 44),
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

  void switchTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
