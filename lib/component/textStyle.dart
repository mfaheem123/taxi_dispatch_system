


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

mozillaTextSemiBoldText({
  double? fontSize,
  color,
  fontWeight,
  double? latterSpacing,
}) {
  return TextStyle(
    fontSize: fontSize ?? 40,
    color: color ?? DynamicColors.textClr,
    fontWeight: fontWeight ?? FontWeight.w600,
    fontFamily: 'MozillaText-SemiBold',
    letterSpacing: latterSpacing ?? 1.5,
  );
}
