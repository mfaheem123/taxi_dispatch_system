import 'package:flutter/material.dart';
import 'app_menu_item.dart';

import 'accounts_menu.dart';
import 'administration_menu.dart';
import 'bookings_menu.dart';
import 'customers_menu.dart';
import 'drivers_menu.dart';
import 'fares_menu.dart';
import 'locations_menu.dart';
import 'menu_actions.dart';
import 'reports_menu.dart';
import 'vehicles_menu.dart';

/// Every top-level menu of the shell's menu bar, in the order they are shown.
///
/// The brand slot comes first on screen but is not a menu: [AppMenuItem]
/// only takes a title / IconData, never a widget, so the CabFlow logo is drawn
/// beside the bar (see `components/app_brand_logo.dart`).
List<AppMenuItem> buildMainMenu(BuildContext context, MenuActions actions) {
  return [
    buildBookingsMenu(actions),
    buildCustomersMenu(actions),
    buildFaresMenu(actions),
    buildLocationsMenu(actions),
    buildDriversMenu(actions),
    buildAccountsMenu(actions),
    buildVehiclesMenu(actions),
    buildAdministrationMenu(actions),
    buildReportsMenu(actions),
    // SETTINGS is no longer a top-bar menu — it lives behind the gear icon on
    // the right of the app bar (see AppbarActionIcons). Built via
    // buildSettingsMenu(context, actions) and passed there.
  ];
}
