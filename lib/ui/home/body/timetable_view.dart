import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:trainkun/model/timetable.dart';
import 'package:trainkun/ui/home/home_viewmodel.dart';
import 'package:trainkun/ui/theme/app_text_theme.dart';
import 'package:trainkun/ui/theme/app_theme.dart';

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
            backgroundColor: appTheme.appColors.primary,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: TabBar(
                indicatorColor: appTheme.appColors.primary,
                labelColor: appTheme.appColors.accent,
                unselectedLabelColor: appTheme.appColors.accent,
                labelStyle: TextStyle(fontSize: 12),
                tabs: tabs,
              ),
            ),
          ),
        ),
        // 時刻表カード一覧
        body: TabBarView(
          children: tabs
              .map(
                (tab) => Padding(
                  padding: EdgeInsets.fromLTRB(6, 10, 6, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: appTheme.appColors.background,
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
                    ),
                  ),
                ),
              )
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
        color: appTheme.appColors.accent,
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
                Text(
                  timetable.line,
                  style: appTheme.textTheme.h40.bold().copyWith(
                        color: viewModel.lineColor[timetable.line],
                      ),
                ),
                Container(
                  child: VerticalDivider(
                    thickness: 3,
                    color: viewModel.lineColor[timetable.line],
                  ),
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
                          style: appTheme.textTheme.h50.primary(),
                        ),
                      ),
                      Text(
                        " / " + timetable.arriveAt,
                        style: appTheme.textTheme.h40.primary(),
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
