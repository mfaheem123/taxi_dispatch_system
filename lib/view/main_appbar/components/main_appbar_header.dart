import 'package:flutter/material.dart';
import 'package:nested_menu_bar/nested_menu_bar.dart';

import 'app_brand_logo.dart';
import 'appbar_action_icons.dart';
import 'main_menu_bar_view.dart';

/// The shell's app bar: brand logo, hover menu bar and the action icons.
///
/// It is its own [PreferredSizeWidget], so the scaffold can take it directly
/// instead of wrapping it in a [PreferredSize].
class MainAppbarHeader extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbarHeader({
    super.key,
    required this.menus,
    required this.onLogout,
  });

  final List<NestedMenuItem> menus;
  final Future<void> Function() onLogout;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 2.3);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Row(
          children: [
            const AppBrandLogo(),
            Expanded(child: MainMenuBarView(menus: menus)),
          ],
        ),
        AppbarActionIcons(onLogout: onLogout),
      ],
    );
  }
}
