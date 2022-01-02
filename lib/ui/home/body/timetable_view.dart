import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:trainkun/model/timetable.dart';
import 'package:trainkun/ui/home/home_viewmodel.dart';

// 時刻表を表示する Widget
class TimetableView extends ViewModelWidget<HomeViewModel> {
  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    List<Tab> tabs = [Tab(text: "平日"), Tab(text: "土・日")];
    return DefaultTabController(
      length: 2,
      initialIndex: viewModel.isHoliday ? 1 : 0,
      child: Scaffold(
        // 平日・祝日選択バー
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
              ),
            ),
          ),
        ),
        // 時刻表カード一覧
        body: TabBarView(
          children: tabs
              .map((tab) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: new RefreshIndicator(
                    onRefresh: viewModel.onRefresh,
                    child: ListView.builder(
                      itemCount: viewModel.timetables[tab.text]!.length,
                      itemBuilder: (_, i) {
                        return TimetableCard(
                          timetable: viewModel.timetables[tab.text]![i],
                        );
                      },
                    ),
                  )))
              .toList(),
        ),
      ),
    );
  }
}

// 時刻表カード
class TimetableCard extends ViewModelWidget<HomeViewModel> {
  final Timetable timetable;

  const TimetableCard({
    Key? key,
    required this.timetable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
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
            viewModel.origin,
            viewModel.destination,
          )),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(timetable.line,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: viewModel.lineColor[timetable.line])),
                Container(
                  child: VerticalDivider(
                      thickness: 3, color: viewModel.lineColor[timetable.line]),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
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
          ),
        ),
      ),
    );
  }
}
