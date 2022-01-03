import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trainkun/ui/theme/app_theme.dart';

import 'services_locator.dart';
import './service/navigation.dart';
import 'ui/start_up/start_up_view.dart';

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
    return MaterialApp(
      title: 'Trainkun',
      theme: AppTheme.main().data,
      navigatorKey: _navigation.navigatorKey,
      onGenerateRoute: NavigationService.generateRoute,
      initialRoute: StartUpView.routeName,
    );
  }
}
