import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:trainkun/ui/favorite/select_favorite.dart';
import 'package:trainkun/ui/home/home_viewmodel.dart';

class HomeAppBar extends ViewModelWidget<HomeViewModel>
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: Text('ばすくん',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 25)),
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
    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
            ]),
            children: [
              SizedBox(
                  child: SelectFavoriteWidget(model: model),
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.9),
            ],
            backgroundColor: Theme.of(context).primaryColor,
          );
        });
  }
}
