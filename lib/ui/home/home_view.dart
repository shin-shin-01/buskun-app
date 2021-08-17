import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:share/share.dart';
import '../../shared/loading.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../favorite/favorite.dart';
import '../../model/timetable.dart';
import './home_viewmodel.dart';

///
class HomeView extends StatelessWidget {
  DateTime datePicked = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => model.isBusy
          ? Loading()
          : Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text('ばすくん',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 25)),
                    ),
                    // 時刻表メイン
                    // - タブ / 時刻表
                    Expanded(child: _timeTableView(context, model)),
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('出発時刻',
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                        InkWell(
                                          onTap: () async {
                                            await model.selectTime(context);
                                          },
                                          child: Text(model.timeString,
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(fontSize: 38)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 5, 0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            // バス停撰択 Dialog
                                            await _showDialog(context, model);
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              _busRouteView(
                                                  context, model, true),
                                              _busRouteView(
                                                  context, model, false),
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // バス停撰択 Dialog
  Future<void> _showDialog(context, HomeViewModel model) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // 乗降車の切り替えをするために Stateful
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              title: Row(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(Icons.directions_bus,
                      color: Theme.of(context).accentColor),
                ),
                Expanded(
                    child: Text("バス停一覧",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 17))),
                IconButton(
                    onPressed: () {
                      setState(() {
                        model.reverseBusPair();
                      });
                    },
                    icon: Icon(Icons.repeat, color: Colors.white, size: 30)),
              ]),
              children: [
                SizedBox(
                    child: FavoriteWidget(model: model),
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.9),
              ],
              backgroundColor: Theme.of(context).primaryColor,
            );
          });
        });
  }

  // 時刻表メイン
  Widget _timeTableView(context, HomeViewModel model) {
    List<Tab> tabs = [Tab(text: "平日"), Tab(text: "土・日")];
    return DefaultTabController(
        length: 2,
        initialIndex: model.isHoliday ? 1 : 0,
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    bottom: PreferredSize(
                        preferredSize: Size.fromHeight(20),
                        child: TabBar(
                          indicatorColor: Theme.of(context).primaryColor,
                          labelColor: Theme.of(context).accentColor,
                          unselectedLabelColor: Theme.of(context).accentColor,
                          labelStyle: TextStyle(fontSize: 12),
                          tabs: tabs,
                        )))),
            body: TabBarView(
                children: tabs
                    .map((tab) => _timeTables(context, model, tab.text))
                    .toList())));
  }

  Widget _timeTables(context, HomeViewModel model, type) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: new RefreshIndicator(
          onRefresh: model.onRefresh,
          child: ListView.builder(
            itemCount: model.timetables[type]!.length,
            itemBuilder: (_, i) {
              return TimetableCard(
                  timetable: model.timetables[type]![i], model: model);
            },
          ),
        ));
  }

  Widget _busRouteView(context, HomeViewModel model, bool isDepartute) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
        child: Row(children: [
          Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Text(
              isDepartute ? "乗車" : "降車",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                isDepartute ? model.origin : model.destination,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 16),
              )),
        ]));
  }
}

class TimetableCard extends StatelessWidget {
  final Timetable timetable;
  final HomeViewModel model;

  const TimetableCard({Key? key, required this.timetable, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: new InkWell(
                onLongPress: () => Share.share(timetable.toShareSentence(
                    model.origin, model.destination, model.isReverse)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(timetable.line,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: model.lineColor[timetable.line])),
                      Container(
                          child: VerticalDivider(
                              thickness: 3,
                              color: model.lineColor[timetable.line])),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 65,
                              child: Text(
                                timetable.departureAt,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(fontSize: 22),
                              ),
                            ),
                            Text(
                              " / " + timetable.arriveAt,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))));
  }
}
