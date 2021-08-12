import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
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
      builder: (context, model, child) => Scaffold(
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
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).accentColor,
                          size: 30,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment(0, 0),
                        child: Text('ばすくん',
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 25)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: InkWell(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  title: Text("お気に入りバス停",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(fontSize: 17)),
                                  children: [
                                    SizedBox(
                                        child: FavoriteWidget(model: model),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8),
                                  ],
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                );
                              });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            'https://picsum.photos/seed/287/600',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // 時刻表メイン
              // - タブ / 時刻表
              Expanded(child: _timeTableView(context, model)),
              Container(
                width: double.infinity,
                height: 100,
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
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('出発時刻',
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  InkWell(
                                    // onTap: () async {
                                    //   await DatePicker.showDatePicker(context,
                                    //       showTitleActions: true,
                                    //       onConfirm: (date) {
                                    //     setState(() => datePicked = date);
                                    //   }, currentTime: DateTime.now());
                                    // },
                                    child: Text(model.timeString,
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(fontSize: 35)),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height: 30,
                                        child: Text(
                                          model.origin,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height: 30,
                                        child: Text(
                                          model.destination,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )),
                                  ],
                                ),
                              ),
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

  // 時刻表メイン
  Widget _timeTableView(context, HomeViewModel model) {
    List<Tab> tabs = [Tab(text: "平日"), Tab(text: "土・日")];
    return DefaultTabController(
        length: 2,
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
      child: ListView.builder(
        itemCount: model.timetables[type]!.length,
        itemBuilder: (_, i) {
          return TimetableCard(timetable: model.timetables[type]![i]);
        },
      ),
    );
  }
}

class TimetableCard extends StatelessWidget {
  final Timetable timetable;

  const TimetableCard({Key? key, required this.timetable}) : super(key: key);

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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  timetable.line,
                  style: Theme.of(context).textTheme.bodyText2,
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 70,
                    child: Text(
                      timetable.departureAt,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 24),
                    ),
                  ),
                  Container(
                    width: 30,
                    child: Icon(Icons.arrow_forward),
                  ),
                  Container(
                    width: 70,
                    child: Text(
                      timetable.arriveAt,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 24),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
