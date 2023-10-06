import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool isNotificationEnabled = true;
  bool isEmailNotification = true;
  bool isPushNotification = true;
  List<String> topics = ['Topic 1', 'Topic 2', 'Topic 3']; // 예시 토픽
  Map<String, bool> topicSelection = {};

  @override
  void initState() {
    super.initState();
    topics.forEach((topic) {
      topicSelection[topic] = false;
    });
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
          '알림설정',
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
          SwitchListTile(
            title: Text('알림 활성화/비활성화', style: titleStyle),
            value: isNotificationEnabled,
            onChanged: (value) {
              setState(() {
                isNotificationEnabled = value;
              });
            },
          ),
          ListTile(
            leading: Checkbox(
              value: isEmailNotification,
              onChanged: isNotificationEnabled
                  ? (value) {
                      setState(() {
                        isEmailNotification = value!;
                      });
                    }
                  : null,
            ),
            title: Text('이메일 알림', style: titleStyle),
          ),
          ListTile(
            leading: Checkbox(
              value: isPushNotification,
              onChanged: isNotificationEnabled
                  ? (value) {
                      setState(() {
                        isPushNotification = value!;
                      });
                    }
                  : null,
            ),
            title: Text('푸시 알림', style: titleStyle),
          ),
          ListTile(
            title: Text('알림 토픽 선택', style: titleStyle),
            subtitle: Column(
              children: topics.map((topic) {
                return CheckboxListTile(
                  title: Text(topic),
                  value: topicSelection[topic],
                  onChanged: isNotificationEnabled
                      ? (value) {
                          setState(() {
                            topicSelection[topic] = value!;
                          });
                        }
                      : null,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
