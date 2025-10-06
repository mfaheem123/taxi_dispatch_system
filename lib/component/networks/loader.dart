

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoaderClass extends StatelessWidget {
  LoaderClass({this.colorOne, this.colorTwo});
  final Color? colorOne;
  final Color? colorTwo;

  @override
  Widget build(BuildContext context) {
    return SpinKitFoldingCube(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven
                ? colorOne ?? DynamicColors.primaryClr
                : colorTwo ?? DynamicColors.primaryClr.withOpacity(0.5),
          ),
        );
      },
    );
  }
}

showLoading() {
  return BotToast.showCustomLoading(
      toastBuilder: (_) => Center(
          child: LoaderClass(
            colorOne: DynamicColors.primaryClr,
            colorTwo: DynamicColors.primaryClr.withOpacity(0.5),
          )),
      animationDuration: Duration(milliseconds: 300));
}
