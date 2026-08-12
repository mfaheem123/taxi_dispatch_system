// The menu bar's chip strip is a tab bar: picking a menu entry for a page that
// is already open must select that chip, not push a duplicate one.
//
// Covers openMenuPage(), which DashboardController.menuBarRefresh() delegates
// to. The controller itself cannot be built in a test (its import chain
// reaches dart:html, and constructing it hangs), which is why the logic lives
// in a leaf file.
import 'package:dashboard_new1/Model/selected_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stand-in for a page widget, identifiable by key so a test can tell which
/// instance ended up on screen.
Widget _page(String id) => SizedBox(key: ValueKey(id));

String _idOf(Object? w) =>
    ((w as Widget?)?.key as ValueKey<String>?)?.value ?? '<none>';

void main() {
  late List<SelectedDropdown> items;

  setUp(() => items = <SelectedDropdown>[]);

  test('re-opening a page does not add a second chip', () {
    openMenuPage(items, title: 'PENDING BOOKINGS', page: _page('pending-1'));
    openMenuPage(items, title: 'PENDING BOOKINGS', page: _page('pending-2'));

    expect(items.length, 1);
    expect(items.single.title, 'PENDING BOOKINGS');
  });

  test('the existing chip is selected, and the previous one is not', () {
    openMenuPage(items, title: 'PENDING BOOKINGS', page: _page('pending-1'));
    openMenuPage(items, title: 'WEB BOOKINGS', page: _page('web-1'));

    // Back to the first one.
    final show =
        openMenuPage(items, title: 'PENDING BOOKINGS', page: _page('pending-2'));

    expect(items.length, 2);
    final pending = items.firstWhere((e) => e.title == 'PENDING BOOKINGS');
    final web = items.firstWhere((e) => e.title == 'WEB BOOKINGS');
    expect(pending.selectedItem, isTrue);
    expect(web.selectedItem, isFalse, reason: 'only one chip stays highlighted');
    expect(_idOf(show), 'pending-2', reason: 'the caller shows this page');
    expect(_idOf(pending.category), 'pending-2',
        reason: 'the chip points at the instance actually on screen');
  });

  test('opening a page for the first time leaves the shown page to the caller',
      () {
    final show = openMenuPage(items, title: 'PRE BOOKINGS', page: _page('pre'));

    expect(show, isNull);
    expect(items.single.selectedItem, isTrue);
    expect(_idOf(items.single.category), 'pre');
  });

  test('distinct titles still each get a chip', () {
    openMenuPage(items, title: 'PRE BOOKINGS', page: _page('pre'));
    openMenuPage(items, title: 'WEB BOOKINGS', page: _page('web'));
    openMenuPage(items, title: 'COMPLETE BOOKINGS', page: _page('complete'));

    expect(items.map((e) => e.title),
        ['PRE BOOKINGS', 'WEB BOOKINGS', 'COMPLETE BOOKINGS']);
    expect(items.where((e) => e.selectedItem).length, 1);
    expect(items.last.selectedItem, isTrue);
  });

  test('a null page selects the chip without changing what is shown', () {
    openMenuPage(items, title: 'PRE BOOKINGS', page: _page('pre'));
    openMenuPage(items, title: 'WEB BOOKINGS', page: _page('web'));

    final show = openMenuPage(items, title: 'PRE BOOKINGS');

    expect(show, isNull);
    expect(items.length, 2);
    expect(items.firstWhere((e) => e.title == 'PRE BOOKINGS').selectedItem,
        isTrue);
    expect(_idOf(items.firstWhere((e) => e.title == 'PRE BOOKINGS').category),
        'pre',
        reason: 'a null page must not wipe the chip it already had');
  });

  test('an untitled entry is added rather than matched against another', () {
    openMenuPage(items, page: _page('one'));
    openMenuPage(items, page: _page('two'));

    expect(items.length, 2);
    expect(items.last.selectedItem, isTrue);
    expect(items.first.selectedItem, isFalse);
  });
}
