import 'package:flutter/material.dart';
import 'package:nested_menu_bar/nested_menu_bar.dart';

import '../../../component/color.dart';

/// The hover menu bar, with the shell's colours already applied.
///
/// The items themselves are built in `menu/main_menu.dart`.
class MainMenuBarView extends StatelessWidget {
  const MainMenuBarView({super.key, required this.menus});

  final List<NestedMenuItem> menus;

  @override
  Widget build(BuildContext context) {
    return NestedMenuBar(
      menuBarPadding: 0.0,
      menus: menus,
      popUpMenuItemBorderRadius: 8,
      menuBarDecoration: BoxDecoration(
        color: DynamicColors.primaryClr,
      ),
      menuBarItemHoverColor: Colors.white,
      menuBarItemColor: Colors.white,
      popUpDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      popUpPadding: 3,
      popUpMenuItemHoverForegroundColor: Colors.white,
      popUpMenuItemForegroundColor: Colors.black,
      popUpMenuItemBackgroundColor: Colors.white,
      popUpMenuItemHoverBackgroundColor: Colors.black,
    );
  }
}
