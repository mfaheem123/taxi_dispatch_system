import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/open_new_tab_web.dart';
import 'app_menu_item.dart';

import '../../booking_view/app_booking.dart';
import '../../booking_view/complete_bookingview.dart';
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
      // Opens the booking form in a new browser tab, on its own route
      // (Routes.createBooking → CreateNewBookingForm). It is not a chip in
      // this tab's strip, so the open-page limit doesn't apply. The route goes
      // in the fragment, the same as the wallboard and drivers map, because
      // _getInitialRoute in main.dart reads it from there.
      onTap: () =>
          openInNewTab('${Uri.base.origin}/#${Routes.createBooking}'),
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
