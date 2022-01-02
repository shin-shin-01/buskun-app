import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:share/share.dart';
import 'package:trainkun/ui/home/body/timetable_view.dart';
import 'package:trainkun/ui/home/home_app_bar.dart';
import 'package:trainkun/ui/home/home_drawer.dart';
import '../../service/authentication.dart';
import '../../services_locator.dart';
import '../../shared/loading.dart';
import '../../ui/favorite/select_favorite.dart';
import '../favorite/favorite.dart';
import '../../model/timetable.dart';
import './home_viewmodel.dart';

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
              backgroundColor: Theme.of(context).primaryColor,
              appBar: HomeAppBar() as PreferredSizeWidget?,
              drawer: HomeDrawer(),
              body: SafeArea(
                child: Column(
                  children: [
                    // 時刻表メイン
                    // - タブ / 時刻表
                    Expanded(child: TimetableView()),
                  ],
                ),
              ),
            ),
    );
  }
}
