


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/textStyle.dart';

class RowButtonWidgetMap extends StatelessWidget {
  RowButtonWidgetMap({super.key,
    this.text, this.onTap, this.color, this.textClr,
    this.widget,
    this.width,
  });
  GestureTapCallback? onTap;
  String? text;
  Color? color;
  Color? textClr;
  Widget? widget;
  double? width;


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: width,
        // padding: EdgeInsets
        //     .symmetric(
        //   horizontal:
        //   horizontalPadding,
        //   vertical:
        //   verticalPadding,
        // ),
        decoration:
        BoxDecoration(
            color: color
          //   color: Colors
          //       .lightBlueAccent,
          //   borderRadius:
          //   BorderRadius
          //       .circular(20),
          //   border: Border.all(
          //       color: Colors
          //           .lightBlueAccent),
        ),
        child: widget?? Center(
          child: Text(
            text?? "MAPS",
            style: headingText(
                fontSize: 14,
                color: textClr
            ),
          ),
        ),
      ),
    );
  }
}
