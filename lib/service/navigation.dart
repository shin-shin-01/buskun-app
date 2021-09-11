import 'package:flutter/material.dart';
import '../ui/home/home_view.dart';
import '../ui/login/login.dart';

class NavigationService {
  /// Navigator を指定するキー
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// currentContext
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// 一個前の画面に戻る
  void pop() => navigatorKey.currentState!.pop();

  /// routeName にページ遷移する (push)
  Future<dynamic> pushNamed({required String routeName, dynamic args}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: args);
  }

  /// 今までの遷移記録を残さない
  Future<dynamic> pushNamedAndRemoveUntil(
      {required String routeName, dynamic args}) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false, arguments: args);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeView.routeName:
        return MaterialPageRoute(builder: (_) => HomeView());
      case LoginView.routeName:
        return MaterialPageRoute(builder: (_) => LoginView());
      default:
        return MaterialPageRoute(builder: (_) => LoginView());
    }
  }
}
