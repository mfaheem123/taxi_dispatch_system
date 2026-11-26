import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Images {
  static get fowardIcon => 'assets/forward.png';
  static get loginBackground => 'assets/LoginBackground.png';
  static get cabFlowLogo => 'assets/cabflow_logo.png';
  static get logo => 'assets/logo.jpeg';

  static String getDriverStatusAsset(String? status) {
    switch (status) {
      case "Accepted":
        return "assets/orange.svg";
      case "Arrived":
        return "assets/bg-secondary.svg";
      case "On Route":
        return "assets/bg-danger.svg";
      case "STC":
        return "assets/stc_icon.svg";
      case "POB":
        return "assets/yellow.svg";
      case "On Break":
        return "assets/amber.svg";
      case "SinBin":
        return "assets/bg-dark.svg";
      default:
        return "assets/bg-green.svg";
    }
  }

  static Widget renderAssetImage(String path, {double? width, double? height, BoxFit fit = BoxFit.contain}) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
      );
    }
  }

  static Widget buildDriverCarIcon(String? status, {double width = 40, double height = 40}) {
    final asset = getDriverStatusAsset(status);
    return renderAssetImage(asset, width: width, height: height);
  }
}
