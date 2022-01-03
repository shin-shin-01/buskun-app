import 'package:flutter/material.dart';
import 'package:trainkun/service/navigation.dart';
import 'package:trainkun/ui/theme/app_text_theme.dart';
import 'package:trainkun/ui/theme/app_theme.dart';
import '../../services_locator.dart';
import '../home/home_viewmodel.dart';
import '../../model/bus_pair.dart';

class FavoriteWidget extends StatelessWidget {
  final HomeViewModel viewModel;
  const FavoriteWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Container(
          decoration: BoxDecoration(
            color: appTheme.appColors.primary,
          ),
          child: ListView.builder(
            itemCount: viewModel.favoriteBusPairs.length,
            itemBuilder: (_, i) {
              return BusPairCard(
                model: viewModel,
                busPair: viewModel.favoriteBusPairs[i],
              );
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

    return Container(
      height: 70,
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: appTheme.appColors.accent,
          child: new InkWell(
            onTap: () {
              model.setBusPairFromFavorite(busPair);
              _navigation.pop();
            },
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _busRouteView(context, model, true),
                    _busRouteView(context, model, false),
                  ],
                )),
          )),
    );
  }

  Widget _busRouteView(context, HomeViewModel model, bool isDepartute) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          isDepartute ? "乗車: " : "降車: ",
          style: appTheme.textTheme.h40.primary(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(
            (isDepartute ^ model.isReverse) ? busPair.first : busPair.second,
            style: appTheme.textTheme.h40.primary(),
          ),
        )
      ],
    );
  }
}
