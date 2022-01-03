import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:trainkun/ui/favorite/select_favorite.dart';
import 'package:trainkun/ui/home/home_viewmodel.dart';
import 'package:trainkun/ui/theme/app_text_theme.dart';
import 'package:trainkun/ui/theme/app_theme.dart';

class HomeAppBar extends ViewModelWidget<HomeViewModel>
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return AppBar(
      backgroundColor: appTheme.appColors.primary,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        'ばすくん',
        textAlign: TextAlign.center,
        style: appTheme.textTheme.h60,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () async {
            // お気に入りバス停撰択 Dialog
            await viewModel.setBusPairs();
            await _showFavoriteDialog(context, viewModel);
          },
          icon: Icon(Icons.favorite),
        )
      ],
    );
  }

  // お気に入りバス停撰択 Dialog
  Future<void> _showFavoriteDialog(context, HomeViewModel model) {
    final Size size = MediaQuery.of(context).size;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
                  "バス停一覧",
                  style: appTheme.textTheme.h40.accent(),
                ),
              ),
            ]),
            children: [
              SizedBox(
                child: SelectFavoriteWidget(model: model),
                height: size.height * 0.6,
                width: size.width * 0.9,
              ),
            ],
            backgroundColor: appTheme.appColors.primary,
          );
        });
  }
}
