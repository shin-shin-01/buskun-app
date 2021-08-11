import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:trainkun/service/navigation.dart';
import '../../services_locator.dart';
import '../home/home_viewmodel.dart';
import '../../model/bus_pair.dart';

class FavoriteWidget extends StatelessWidget {
  final HomeViewModel model;
  const FavoriteWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _navigation = servicesLocator<NavigationService>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: model.busPairs.length,
                      itemBuilder: (_, i) {
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: BusPairCard(
                              model: model, busPair: model.busPairs[i]),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                model.deleteFavoriteBusPair(model.busPairs[i]);
                                // TODO: fix - now, pop when delete BusPair cuz BusPairCard not removed
                                _navigation.pop();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Theme.of(context).accentColor,
      child: new InkWell(
        onTap: () {
          model.setBusPairFromFavorite(busPair);
          _navigation.pop();
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 3, 3, 3),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                    child: Text('出発 :',
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      busPair.origin,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                    child: Text(
                      '到着 :',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      busPair.destination,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
