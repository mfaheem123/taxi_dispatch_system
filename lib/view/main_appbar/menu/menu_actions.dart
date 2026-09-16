import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../../../component/networks/api.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';

/// The one place the menu's repeated `onTap` body lives.
///
/// Every entry used to spell the same three steps out by hand: refuse to open
/// one page too many, check a permission, then swap the page in and push a chip
/// for it. A menu file now just names the title, the page and the permission.
class MenuActions {
  MenuActions({required this.controller, required this.refresh});

  /// The shell's controller — it holds the open chips and the shown page.
  final DashboardController controller;

  /// The shell's `setState`, so picking a menu entry still rebuilds the host.
  final void Function(VoidCallback) refresh;

  /// How many pages may be open at the same time.
  static const int maxOpenPages = 20;

  static const String limitReachedMessage =
      "Maintain at least 20 pages open simultaneously.";

  bool get canOpenAnotherPage =>
      controller.selectedMenuItems.length < maxOpenPages;

  /// Everything the signed-in user is allowed to do.
  List get permissions => Api().sp.read('all_permissions') ?? [];

  bool hasPermission(String permission) => permissions.contains(permission);

  void showLimitReached() => BotToast.showText(text: limitReachedMessage);

  /// Runs [action] unless the open-page limit is already reached.
  ///
  /// [warnWhenFull] is off for the few entries that used to swallow the limit
  /// without telling the user.
  void guard(VoidCallback action, {bool warnWhenFull = true}) {
    if (canOpenAnotherPage) {
      action();
    } else if (warnWhenFull) {
      showLimitReached();
    }
  }

  /// Shows [page] and gives it a chip titled [title], with no guard of any kind.
  ///
  /// [page] is called twice on purpose: the shown page and the chip's page are
  /// separate instances, exactly as the hand-written entries built them.
  void showPage(String title, Widget Function() page) {
    refresh(() {
      controller.currentPage.value = page();
      controller.menuBarRefresh(title: title, pageName: page());
    });
  }

  /// The standard menu entry: the open-page guard, an optional [permission],
  /// an optional [beforeOpen] hook (usually a form reset), then the page.
  void openPage({
    required String title,
    required Widget Function() page,
    String? permission,
    VoidCallback? beforeOpen,
  }) {
    guard(() {
      if (permission != null && !hasPermission(permission)) return;
      refresh(() {
        beforeOpen?.call();
        controller.currentPage.value = page();
        controller.menuBarRefresh(title: title, pageName: page());
      });
    });
  }

  /// A menu entry that opens a dialog over whichever page is already shown —
  /// the chip is pushed for the current page, not for a new one.
  void openDialog({
    required BuildContext context,
    required String title,
    required WidgetBuilder builder,
  }) {
    guard(() {
      controller.menuBarRefresh(
        title: title,
        pageName: controller.currentPage.value,
      );
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: builder,
      );
    });
  }
}
