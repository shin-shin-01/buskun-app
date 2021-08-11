import 'package:flutter/material.dart';

class NavigationService {
  /// Navigator を指定するキー
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// currentContext
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// 一個前の画面に戻る
  void pop() => navigatorKey.currentState!.pop();
}
