import 'package:flutter/material.dart';
import '../../model/bus_pair.dart';

class FavoriteWidget extends StatelessWidget {
  final List<BusPair> busPairs;

  const FavoriteWidget({Key? key, required this.busPairs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      itemCount: busPairs.length,
                      itemBuilder: (_, i) {
                        return BusPairCard(busPair: busPairs[i]);
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
  final BusPair busPair;

  const BusPairCard({Key? key, required this.busPair}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Theme.of(context).accentColor,
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
    );
  }
}
