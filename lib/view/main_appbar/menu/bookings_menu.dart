import 'package:get/get.dart';
import 'package:nested_menu_bar/nested_menu_bar.dart';

import '../../booking_view/app_booking.dart';
import '../../booking_view/complete_bookingview.dart';
import '../../booking_view/create_new_booking_form.dart';
import '../../booking_view/multi_booking.dart';
import '../../booking_view/pending_booking.dart';
import '../../booking_view/pre_booking.dart';
import '../../booking_view/trash_booking.dart';
import '../../booking_view/web_booking.dart';
import 'menu_actions.dart';

/// The BOOKINGS menu.
NestedMenuItem buildBookingsMenu(MenuActions actions) {
  return NestedMenuItem(title: "BOOKINGS", children: [
    NestedMenuItem(
      title: "CREATE BOOKINGS",
      // The booking form is pushed as a route of its own instead of becoming a
      // chip, so the open-page limit only warns here — the form opens either
      // way.
      onTap: () {
        if (!actions.canOpenAnotherPage) {
          actions.showLimitReached();
        }
        Get.to(CreateNewBookingForm());
      },
    ),
    NestedMenuItem(
      title: "COMPLETE BOOKINGS",
      onTap: () => actions.openPage(
        title: "COMPLETE BOOKINGS",
        page: () => CompleteBookingsScreen(),
      ),
    ),
    NestedMenuItem(
      title: "PENDING BOOKINGS",
      onTap: () => actions.openPage(
        title: "PENDING BOOKINGS",
        page: () => PendingBooking(),
      ),
    ),
    NestedMenuItem(
      title: "PRE BOOKINGS",
      onTap: () => actions.openPage(
        title: "PRE BOOKINGS",
        page: () => PreBooking(),
      ),
    ),
    NestedMenuItem(
      title: "WEB BOOKINGS",
      onTap: () => actions.openPage(
        title: "WEB BOOKINGS",
        page: () => WebBooking(),
      ),
    ),
    NestedMenuItem(
      title: "APP BOOKINGS",
      onTap: () => actions.openPage(
        title: "APP BOOKINGS",
        page: () => AppBooking(),
      ),
    ),
    NestedMenuItem(
      title: "MULTI BOOKINGS",
      onTap: () => actions.openPage(
        title: "MULTI BOOKINGS",
        page: () => MultiBooking(),
      ),
    ),
    NestedMenuItem(
      title: "TRASH BOOKINGS",
      onTap: () => actions.openPage(
        title: "TRASH BOOKINGS",
        page: () => TrashBooking(),
        permission: 'read_trash_booking',
      ),
    ),
  ]);
}
