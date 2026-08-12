// The menu-bar chip strip is a tab bar: picking a menu entry for a page that
// is already open must select that chip, not push a duplicate one.
//
// Has to run with --platform chrome (DashboardController reaches dart:html
// through its imports), and that means compiling the app to JS first.
@Timeout(Duration(minutes: 40))
library;

import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stand-in for a page widget, identifiable by key so the test can tell which
/// instance ended up on screen.
Widget _page(String id) => SizedBox(key: ValueKey(id));

String _idOf(Widget? w) => (w?.key as ValueKey<String>?)?.value ?? '<none>';

void main() {
  late DashboardController controller;

  setUp(() {
    controller = DashboardController();
  });

  test('re-opening a page does not add a second chip', () {
    controller.menuBarRefresh(
        title: 'PENDING BOOKINGS', pageName: _page('pending-1'));
    controller.menuBarRefresh(
        title: 'PENDING BOOKINGS', pageName: _page('pending-2'));

    expect(controller.selectedMenuItems.length, 1);
    expect(controller.selectedMenuItems.single.title, 'PENDING BOOKINGS');
  });

  test('the existing chip is selected and its page shown', () {
    controller.menuBarRefresh(
        title: 'PENDING BOOKINGS', pageName: _page('pending-1'));
    controller.menuBarRefresh(title: 'WEB BOOKINGS', pageName: _page('web-1'));

    // Back to the first one.
    controller.menuBarRefresh(
        title: 'PENDING BOOKINGS', pageName: _page('pending-2'));

    expect(controller.selectedMenuItems.length, 2);
    final pending = controller.selectedMenuItems
        .firstWhere((e) => e.title == 'PENDING BOOKINGS');
    final web =
        controller.selectedMenuItems.firstWhere((e) => e.title == 'WEB BOOKINGS');
    expect(pending.selectedItem, isTrue);
    expect(web.selectedItem, isFalse, reason: 'only one chip stays highlighted');
    expect(_idOf(controller.currentPage.value), 'pending-2');
    expect(_idOf(pending.category), 'pending-2',
        reason: 'the chip points at the instance actually on screen');
  });

  test('distinct titles still each get a chip', () {
    controller.menuBarRefresh(title: 'PRE BOOKINGS', pageName: _page('pre'));
    controller.menuBarRefresh(title: 'WEB BOOKINGS', pageName: _page('web'));
    controller.menuBarRefresh(
        title: 'COMPLETE BOOKINGS', pageName: _page('complete'));

    expect(controller.selectedMenuItems.map((e) => e.title),
        ['PRE BOOKINGS', 'WEB BOOKINGS', 'COMPLETE BOOKINGS']);
    expect(controller.selectedMenuItems.where((e) => e.selectedItem).length, 1);
    expect(controller.selectedMenuItems.last.selectedItem, isTrue);
  });

  test('a null pageName leaves the shown page alone', () {
    controller.menuBarRefresh(title: 'PRE BOOKINGS', pageName: _page('pre'));
    controller.currentPage.value = _page('something-else');

    controller.menuBarRefresh(title: 'PRE BOOKINGS');

    expect(controller.selectedMenuItems.length, 1);
    expect(controller.selectedMenuItems.single.selectedItem, isTrue);
    expect(_idOf(controller.currentPage.value), 'something-else');
  });
}
