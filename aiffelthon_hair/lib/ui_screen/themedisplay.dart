import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class ThemeDisplayScreen extends StatefulWidget {
  @override
  _ThemeDisplayScreenState createState() => _ThemeDisplayScreenState();
}

class _ThemeDisplayScreenState extends State<ThemeDisplayScreen> {
  Color currentColor = Colors.blue;

  Future<void> _showColorPickerDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('색상 선택'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                setState(() {
                  currentColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<ThemeProvider>(context, listen: false)
                    .setBackgroundColor(currentColor);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('테마 및 디스플레이'),
      ),
      body: Container(
        color: themeProvider.isDarkMode ? Colors.black : Colors.white, // 배경색 설정
        child: ListView(
          children: [
            SwitchListTile(
              title: Text("어두운 모드"),
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
            ListTile(
              title: Text("배경색 선택"),
              trailing: Icon(Icons.color_lens),
              onTap: _showColorPickerDialog,
            ),
          ],
        ),
      ),
    );
  }
}
