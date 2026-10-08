import 'package:flutter/widgets.dart';

/// One entry of the shell's menu bar: a leaf with [onTap], or a sub-menu with
/// [children]. Drawn by `components/main_menu_bar_view.dart`.
///
/// Replaces the nested_menu_bar package's NestedMenuItem, whose pop-ups only
/// close when the mouse leaves them — on a touch screen (iPad, phone browser)
/// there is no "leave", so the menu stayed open after a tap.
class AppMenuItem {
  AppMenuItem({
    required this.title,
    this.icon,
    this.onTap,
    this.children,
  });

  final String title;

  /// Shown before [title] on a top-level menu button (like the mycabify bar).
  /// Sub-menu entries leave this null — their rows are text only.
  final IconData? icon;

  /// Runs when the entry is tapped / clicked. The menu closes first.
  final void Function()? onTap;

  /// Non-empty for a sub-menu.
  final List<AppMenuItem>? children;

  bool get hasChildren => children != null && children!.isNotEmpty;
}
