import 'package:flutter/material.dart';

/// One chip in the menu bar's open-pages strip.
///
/// Moved out of tabbarview.dart (which re-exports it, so every existing import
/// still resolves) to keep it and [openMenuPage] reachable from a plain VM
/// test — tabbarview's import chain pulls in dart:html.
class SelectedDropdown {
  String? title;
  var category;
  bool selectedItem = false;
  SelectedDropdown({this.title, this.selectedItem = false, this.category});
}

/// Opens [title]'s page in the chip strip [items] and returns the page that
/// should become visible, or null when the caller should leave the shown page
/// as it is.
///
/// The strip is a tab bar, so a title that is already open is NOT added a
/// second time: re-picking a menu entry used to push another chip for the same
/// page every single time. The chip already there is selected instead.
///
/// Titles are the match key. The widgets cannot be compared — every caller
/// builds a fresh instance (`pageName: PendingBooking()`), so `==` never
/// matches — and the title is the identity the user sees on the chip, as well
/// as the key the call sites that dedupe by hand already use (see
/// list_of_accountScreen.dart's "UPDATE ACCOUNT").
Widget? openMenuPage(
  List<SelectedDropdown> items, {
  String? title,
  Widget? page,
}) {
  final selected = items.indexWhere((item) => item.selectedItem == true);
  if (selected != -1) {
    items[selected].selectedItem = false;
  }

  // Every caller passes a title today; an untitled chip is not something to
  // match on, so it just gets added.
  final existing =
      title == null ? -1 : items.indexWhere((item) => item.title == title);

  if (existing != -1) {
    items[existing].selectedItem = true;
    if (page == null) return null;
    // Point the chip at the instance being shown now, so tapping away and back
    // does not swap in the one built on the first visit.
    items[existing].category = page;
    return page;
  }

  items.add(
      SelectedDropdown(title: title, selectedItem: true, category: page));
  // Nothing to return: on this path the callers set the page themselves, as
  // they always have.
  return null;
}
