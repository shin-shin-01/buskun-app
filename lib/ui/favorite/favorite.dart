import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:trainkun/service/navigation.dart';
import '../../services_locator.dart';
import '../home/home_viewmodel.dart';
import '../../model/bus_pair.dart';

class FavoriteWidget extends StatelessWidget {
  final HomeViewModel model;
  const FavoriteWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
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

    return Container(
      height: 70,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Theme.of(context).accentColor,
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('乗車 :',
                          style: Theme.of(context).textTheme.bodyText2),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          busPair.first,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '降車 :',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          busPair.second,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
