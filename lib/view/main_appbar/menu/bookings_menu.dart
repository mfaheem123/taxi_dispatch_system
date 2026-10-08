import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_menu_item.dart';

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
AppMenuItem buildBookingsMenu(MenuActions actions) {
  return AppMenuItem(title: "BOOKINGS", icon: Icons.event_note, children: [
    AppMenuItem(
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
    AppMenuItem(
      title: "COMPLETE BOOKINGS",
      onTap: () => actions.openPage(
        title: "COMPLETE BOOKINGS",
        page: () => CompleteBookingsScreen(),
      ),
    ),
    AppMenuItem(
      title: "PENDING BOOKINGS",
      onTap: () => actions.openPage(
        title: "PENDING BOOKINGS",
        page: () => PendingBooking(),
      ),
    ),
    AppMenuItem(
      title: "PRE BOOKINGS",
      onTap: () => actions.openPage(
        title: "PRE BOOKINGS",
        page: () => PreBooking(),
      ),
    ),
    AppMenuItem(
      title: "WEB BOOKINGS",
      onTap: () => actions.openPage(
        title: "WEB BOOKINGS",
        page: () => WebBooking(),
      ),
    ),
    AppMenuItem(
      title: "APP BOOKINGS",
      onTap: () => actions.openPage(
        title: "APP BOOKINGS",
        page: () => AppBooking(),
      ),
    ),
    AppMenuItem(
      title: "MULTI BOOKINGS",
      onTap: () => actions.openPage(
        title: "MULTI BOOKINGS",
        page: () => MultiBooking(),
      ),
    ),
    AppMenuItem(
      title: "TRASH BOOKINGS",
      onTap: () => actions.openPage(
        title: "TRASH BOOKINGS",
        page: () => TrashBooking(),
        permission: 'read_trash_booking',
      ),
    ),
  ]);
}
