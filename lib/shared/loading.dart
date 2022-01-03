import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trainkun/ui/theme/app_theme.dart';

// Loading 画面
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.appColors.primary,
      child: Center(
        child: SpinKitCubeGrid(
          color: appTheme.appColors.accent,
          size: 50,
        ),
      ),
    );
  }
}
