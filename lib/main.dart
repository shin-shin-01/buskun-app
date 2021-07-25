import 'package:flutter/material.dart';
import './ui/login/login.dart';
import './ui/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// - #FF353537 (Black)
    /// - #FFFFFAFA (White）
    /// - #FFEEEEEE (defaultBackground grey)
    final appTheme = ThemeData(
      primaryColor: Color(0xFF353537),
      accentColor: Color(0xFFFFFAFA),
      backgroundColor: Color(0xFFEEEEEE),
      textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Color(0xFFFFFAFA),
            fontFamily: 'Poppins',
            fontSize: 15,
          ),
          bodyText2: TextStyle(
            color: Color(0xFF353537),
            fontFamily: 'Poppins',
            fontSize: 15,
          )),
    );

    return MaterialApp(
        title: 'Trainkun',
        theme: appTheme,
        // home: LoginWidget(),
        home: HomeWidget());
  }
}
