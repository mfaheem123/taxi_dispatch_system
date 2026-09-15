import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';

import '../view/auth/edit_jobs.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../view/dashboard_view/dashboard/defult_dashboard_view.dart';

/// Title of the chip the booking editor is opened under. Every caller shares
/// the one title, so re-editing any booking reuses the same tab instead of
/// pushing a new chip per booking.
const String kEditBookingTabTitle = 'BOOKING | EDIT';

/// Maximum number of chips that may be OPEN at once. The cap is on *opening*
/// a tab — a page already in the strip just gets selected, which has to keep
/// working once the cap is reached.
const int kMaxOpenTabs = 20;

/// Opens the booking editor for [id] in the dashboard's menu-bar tab strip.
///
/// [id] is the booking id as the list models carry it (a `String?`); it is
/// parsed here so callers never have to, and a null/unparseable id opens the
/// editor on an empty booking.
///
/// Returns `false` without opening anything when the tab is not already open
/// and the strip is already full, after showing the user a toast.
///
/// Callers that rebuild on the tab strip should wrap this in `setState`:
///
/// ```dart
/// setState(() => openEditBookingTab(item.id));
/// ```
bool openEditBookingTab(String? id) {
  final DashboardController dashboardController = Get.find();

  final alreadyOpen = dashboardController.selectedMenuItems
      .any((tab) => tab.title == kEditBookingTabTitle);
  if (!alreadyOpen &&
      dashboardController.selectedMenuItems.length >= kMaxOpenTabs) {
    BotToast.showText(
        text: "You can keep at most $kMaxOpenTabs pages open at once. "
            "Close one and try again.");
    return false;
  }

  // One instance for both assignments: menuBarRefresh only assigns currentPage
  // when the tab already existed, so the freshly-added-chip path sets it here.
  // Building it twice handed the strip a different widget from the one on
  // screen.
  final page = EditJobsWidget(booking: EditJobDetails(id: int.tryParse(id ?? '')));
  dashboardController.currentPage.value = page;
  dashboardController.menuBarRefresh(
      title: kEditBookingTabTitle, pageName: page);
  return true;
}

/// Closes the booking-editor tab and drops the user back on the dashboard.
///
/// The chip is REMOVED from the strip, not just deselected: the booking has
/// been saved, so leaving a stale "BOOKING | EDIT" chip behind would reopen a
/// form for a job the user is done with — and it would keep counting against
/// the [kMaxOpenTabs] cap.
///
/// Safe to call when the editor was opened on its own route rather than as a
/// tab: removeWhere on a strip that has no such chip is a no-op, and the
/// dashboard is still the right place to land.
void closeEditBookingTab() {
  final DashboardController dashboardController = Get.find();

  dashboardController.selectedMenuItems
      .removeWhere((tab) => tab.title == kEditBookingTabTitle);
  // Whatever chip stays behind must not be left marked selected, or the strip
  // paints two highlighted chips once a later one is picked.
  for (final tab in dashboardController.selectedMenuItems) {
    tab.selectedItem = false;
  }
  dashboardController.currentPage.value = ByDefaultDashboard();
  dashboardController.update();
}
