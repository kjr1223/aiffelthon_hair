import 'package:aiffelthon_hair/firebase_auth/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:aiffelthon_hair/ui_screen/navigation_screen.dart';
import 'ui_screen/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: ThemeData(
        brightness:
            themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyText1: TextStyle(
              fontFamily: 'DoHyeonRegular',
              fontSize: themeProvider.fontSize,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black),
          bodyText2: TextStyle(
              fontFamily: 'DoHyeonRegular',
              fontSize: themeProvider.fontSize,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black),
        ),
        scaffoldBackgroundColor: themeProvider.backgroundColor,
      ),
      home: const NavigationScreen(),
    );
  }
}
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Upload and Result',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ,
//     );
//   }
// }
