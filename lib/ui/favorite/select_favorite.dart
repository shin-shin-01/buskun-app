import 'package:flutter/material.dart';
import 'package:trainkun/service/navigation.dart';
import 'package:trainkun/ui/home/home_view.dart';
import 'package:trainkun/ui/theme/app_text_theme.dart';
import 'package:trainkun/ui/theme/app_theme.dart';
import '../../services_locator.dart';
import '../home/home_viewmodel.dart';
import '../../model/bus_pair.dart';

// 全てのバス停からお気に入りのバス停を選択
class SelectFavoriteWidget extends StatelessWidget {
  final HomeViewModel model;
  const SelectFavoriteWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: appTheme.appColors.primary,
          ),
          child: ListView.builder(
            itemCount: model.busPairs.length,
            itemBuilder: (_, i) {
              return BusPairCard(model: model, busPair: model.busPairs[i]);
            },
          ),
        ));
  }
}

class BusPairCard extends StatelessWidget {
  final HomeViewModel model;
  final BusPair busPair;

  const BusPairCard({Key? key, required this.model, required this.busPair})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _navigation = servicesLocator<NavigationService>();
    final isFavorite = model.isFavoriteBusPair(busPair);

    return Container(
      height: 70,
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: isFavorite ? Colors.blue : appTheme.appColors.accent,
          child: new InkWell(
            onTap: () {
              isFavorite
                  ? model.removeBusPairFavorite(busPair)
                  : model.setBusPairFavorite(busPair);
              // TODO: 処理を変更
              _navigation.pushNamed(routeName: HomeView.routeName);
            },
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _busRouteView(context, model, true, isFavorite),
                    _busRouteView(context, model, false, isFavorite),
                  ],
                )),
          )),
    );
  }

  Widget _busRouteView(
      context, HomeViewModel model, bool isDepartute, bool isFavorite) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(isDepartute ? "乗車: " : "降車: ",
            style: isFavorite
                ? appTheme.textTheme.h40.accent()
                : appTheme.textTheme.h40.primary()),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(
              (isDepartute ^ model.isReverse) ? busPair.first : busPair.second,
              style: isFavorite
                  ? appTheme.textTheme.h40.accent()
                  : appTheme.textTheme.h40.primary()),
        )
      ],
    );
  }
}
