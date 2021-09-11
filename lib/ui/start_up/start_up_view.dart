import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../shared/loading.dart';
import 'start_up_viewmodel.dart';

class StartUpView extends StatelessWidget {
  ///
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (content, model, child) => Loading(),
    );
  }
}
