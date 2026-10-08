import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_menu_item.dart';

import '../../locations_view/controller/locations_controller.dart';
import '../../locations_view/location/localization_screen.dart';
import '../../locations_view/location/location_formScreen.dart';
import '../../locations_view/location/location_listScreen.dart';
import '../../locations_view/location/zone_listScreen.dart';
import '../../locations_view/location/zone_screen.dart';
import 'menu_actions.dart';

/// The LOCATIONS menu.
AppMenuItem buildLocationsMenu(MenuActions actions) {
  return AppMenuItem(title: "LOCATIONS", icon: Icons.location_on, children: [
    AppMenuItem(
      title: "CREATE LOCATIONS",
      onTap: () => actions.openPage(
        title: "CREATE LOCATIONS",
        page: () => LocationForm(),
        permission: 'create_location',
        beforeOpen: () {
          if (Get.isRegistered<LocationController>()) {
            Get.find<LocationController>().clearLocationForm();
          }
        },
      ),
    ),
    AppMenuItem(
      title: "LIST OF LOCATIONS",
      onTap: () => actions.openPage(
        title: "LIST OF LOCATIONS",
        page: () => LocationListScreen(),
        permission: 'read_location',
      ),
    ),
    AppMenuItem(
      title: "CREATE ZONE",
      onTap: () => actions.openPage(
        title: "CREATE ZONE",
        page: () => ZoneScreen(),
        permission: 'create_zone',
      ),
    ),
    AppMenuItem(
      title: "LIST OF ZONES",
      onTap: () => actions.openPage(
        title: "LIST OF ZONES",
        page: () => ZoneListScreen(),
        permission: 'read_zone',
      ),
    ),
    AppMenuItem(
      title: "LOCALIZATION",
      onTap: () => actions.openPage(
        title: "LOCALIZATION",
        page: () => LocalizationScreen(),
      ),
    ),
  ]);
}
