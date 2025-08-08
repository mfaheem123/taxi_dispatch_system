


import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';

headingText({
  double? fontSize,
  color,
  fontWeight,
  double? latterSpacing,
}) {
  return TextStyle(
    fontSize: fontSize ?? 40,
    color: color ?? DynamicColors.textClr,
    fontWeight: fontWeight ?? FontWeight.w600,
    fontFamily: 'headingText',
    letterSpacing: latterSpacing ?? 1.5,
  );
}

TextStyle mozillaTextSemiBoldText({
  BuildContext? context, // context lena zaroori hai for MediaQuery
  double? fontSize,
  Color? color,
  FontWeight? fontWeight,
}) {
  double finalFontSize = fontSize ?? 20;

  if (context != null) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Responsive font size
    if (screenWidth < 600) {
      // Mobile
      finalFontSize = fontSize ?? 16;
    } else if (screenWidth >= 600 && screenWidth < 1024) {
      // Tablet
      finalFontSize = fontSize ?? 18;
    } else {
      // Desktop / Web
      finalFontSize = fontSize ?? 20;
    }
  }

  return TextStyle(
    fontSize: finalFontSize,
    color: color ?? DynamicColors.whiteClr,
    fontWeight: fontWeight ?? FontWeight.w700,
  );
}
