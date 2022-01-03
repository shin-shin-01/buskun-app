import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:trainkun/ui/home/body/bottom_menu_view.dart';
import 'package:trainkun/ui/home/body/timetable_view.dart';
import 'package:trainkun/ui/home/home_app_bar.dart';
import 'package:trainkun/ui/home/home_drawer.dart';
import 'package:trainkun/shared/loading.dart';
import 'package:trainkun/ui/home/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => model.isBusy
          ? Loading()
          : Scaffold(
              appBar: HomeAppBar(),
              drawer: HomeDrawer(),
              body: Column(
                children: [
                  // 時刻表メイン
                  // - タブ / 時刻表
                  Expanded(child: TimetableView()),
                  BottomMenuView(),
                ],
              ),
            ),
    );
  }
}
