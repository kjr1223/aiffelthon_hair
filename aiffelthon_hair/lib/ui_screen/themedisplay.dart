import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeDisplayScreen extends StatefulWidget {
  @override
  _ThemeDisplayScreenState createState() => _ThemeDisplayScreenState();
}

class _ThemeDisplayScreenState extends State<ThemeDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('테마 및 디스플레이'),
          backgroundColor:
              themeProvider.isDarkMode ? Colors.black : Colors.green,
        ),
        body: Container(
          color: themeProvider.isDarkMode ? Colors.black : Colors.white,
          child: ListView(
            children: [
              SwitchListTile(
                title: Text("Dark Mode"),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleDarkMode();
                },
              ),
              ListTile(
                title: Text("폰트 크기"),
                trailing: DropdownButton<double>(
                  value: themeProvider.fontSize,
                  items: <double>[10, 12, 14, 16, 18, 20, 22, 24]
                      .map((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (double? newValue) {
                    if (newValue != null) {
                      themeProvider.setFontSize(newValue);
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
