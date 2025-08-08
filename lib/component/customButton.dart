


import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'color.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key,this.onTap,
  this.width,
    this.btnText,
    this.height,
    this.borderRadius,
    this.style,
    this.verticalPadding,
    this.btnColor
  });

  final GestureTapCallback? onTap;
  double? width;
  double? height;
  double? borderRadius;
  double? verticalPadding;
  String? btnText;
  final TextStyle? style;
  final Color? btnColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width ?? Get.width/2.5,
        height:height?? 45,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: verticalPadding??13),
          decoration: BoxDecoration(
            color:btnColor?? DynamicColors.primaryClr,
            borderRadius: BorderRadius.circular(borderRadius??20),
          ),
          child: Center(
            child: Text( btnText??AppText.login,
              style:style?? mozillaTextSemiBoldText(
                  fontSize: 20,
                  color: DynamicColors.whiteClr,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
