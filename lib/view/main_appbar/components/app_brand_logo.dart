import 'package:flutter/material.dart';

import '../../../component/color.dart';

/// CabFlow logo that fills the menu bar's brand slot.
///
/// [NestedMenuItem] only takes a title / IconData, never a widget, so the logo
/// is rendered next to the menu bar instead of as an item inside it.
class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      color: DynamicColors.primaryClr,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Image.asset(
          'assets/cabflow_logo.png',
          height: 26,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
