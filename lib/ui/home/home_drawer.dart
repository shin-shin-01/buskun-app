import 'package:flutter/material.dart';
import 'package:trainkun/service/authentication.dart';

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
          child: Text('ばすくん'),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      ListTile(
        title: Text(_auth.userProfile["displayName"]!,
            style: Theme.of(context).textTheme.bodyText2),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_auth.userProfile["photoURL"]!),
          backgroundColor: Colors.transparent, // 背景色
          radius: 16, // 表示したいサイズの半径を指定
        ),
      ),
      ListTile(
        title: InkWell(
          onTap: () async => await _auth.signOut(),
          child: Text("ログアウト", style: Theme.of(context).textTheme.bodyText2),
        ),
        leading: Icon(Icons.logout),
      ),
    ]));
  }
}
