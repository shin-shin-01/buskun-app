import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:trainkun/ui/favorite/favorite.dart';
import 'package:trainkun/ui/home/home_viewmodel.dart';
import 'package:trainkun/ui/theme/app_text_theme.dart';
import 'package:trainkun/ui/theme/app_theme.dart';

// 画面下部 バス停・時刻を選択する Widget
class BottomMenuView extends ViewModelWidget<HomeViewModel> {
  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Container(
      height: 130,
      color: appTheme.appColors.primary,
      child: Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Stack(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        Text(
                          '出発時刻',
                          style: appTheme.textTheme.h40.accent(),
                        ),
                        InkWell(
                          onTap: () async =>
                              await viewModel.selectTime(context),
                          child: Text(
                            viewModel.timeString,
                            style: appTheme.textTheme.h80.accent(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: GestureDetector(
                          onTap: () async =>
                              // バス停撰択 Dialog
                              await _showSelectBusDialog(context, viewModel),
                          child: Column(
                            children: [
                              _busRouteView(context, viewModel, true),
                              _busRouteView(context, viewModel, false),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  // バス停撰択 Dialog
  Future<void> _showSelectBusDialog(context, HomeViewModel model) {
    final Size size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // 乗降車の切り替えをするために Stateful
        return StatefulBuilder(builder: (context, setState) {
          return SimpleDialog(
            title: Row(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Icon(
                  Icons.directions_bus,
                  color: appTheme.appColors.accent,
                ),
              ),
              Expanded(
                  child: Text(
                "お気に入りバス停",
                style: appTheme.textTheme.h40.accent(),
              )),
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
                  child: FavoriteWidget(viewModel: model),
                  height: size.height * 0.6,
                  width: size.width * 0.9),
            ],
            backgroundColor: appTheme.appColors.primary,
          );
        });
      },
    );
  }

  // 乗車・降車バス停を表示
  Widget _busRouteView(context, HomeViewModel model, bool isDepartute) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: appTheme.appColors.blue, width: 2),
            ),
            child: Text(
              isDepartute ? "乗車" : "降車",
              style: appTheme.textTheme.h40.accent().bold(),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              isDepartute ? model.origin : model.destination,
              style: appTheme.textTheme.h40.accent(),
            ),
          ),
        ],
      ),
    );
  }
}
