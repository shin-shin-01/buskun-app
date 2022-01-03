import 'package:flutter/material.dart';
import 'package:trainkun/service/authentication.dart';
import 'package:trainkun/ui/theme/app_text_theme.dart';
import 'package:trainkun/ui/theme/app_theme.dart';

import '../../services_locator.dart';

/// ドロワーメニュー
class HomeDrawer extends StatelessWidget {
  final _auth = servicesLocator<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: <Widget>[
      Container(
        height: 70.0,
        child: DrawerHeader(
          child: Text(
            'ばすくん',
            style: appTheme.textTheme.h40.accent(),
          ),
          decoration: BoxDecoration(
            color: appTheme.appColors.primary,
          ),
        ),
      ),
      ListTile(
        title: Text(
          _auth.userProfile["displayName"]!,
          style: appTheme.textTheme.h40.primary(),
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_auth.userProfile["photoURL"]!),
          backgroundColor: Colors.transparent, // 背景色
          radius: 16, // 表示したいサイズの半径を指定
        ),
      ),
      ListTile(
        title: InkWell(
          onTap: () async => await _auth.signOut(),
          child: Text(
            "ログアウト",
            style: appTheme.textTheme.h40.primary(),
          ),
        ),
        leading: Icon(Icons.logout),
      ),
    ]));
  }
}
