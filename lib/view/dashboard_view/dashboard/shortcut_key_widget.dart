


import 'package:flutter/material.dart';

import '../../../component/color.dart';
import '../../../component/textStyle.dart';

class ShortcutKeyWidget extends StatelessWidget {
  ShortcutKeyWidget({super.key,  this.keyss,this.valuess});
  String? keyss;
  String? valuess;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            height: 25,
            width: 25,
            // padding: EdgeInsets.all(8),
            color: DynamicColors.textClr,
            child: Center(
              child: Text(keyss??"F1",
                style: headingText(
                    fontSize: 14,
                    color: DynamicColors.whiteClr
                ),
              ),
            ),
          ),
          SizedBox(width: 4,),
          Text(valuess??"BASE ADDRESS",
            style: headingText(
                fontSize: 15,
                latterSpacing: 1.0
            ),
          )
        ],
      ),
    );
  }
}
