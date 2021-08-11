import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trainkun/service/navigation.dart';

import 'services_locator.dart';
import './ui/login/login.dart';
import './ui/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final _navigation = servicesLocator<NavigationService>();

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
        navigatorKey: _navigation.navigatorKey,
        // home: LoginWidget(),
        home: HomeView());
  }
}
