import 'package:nested_menu_bar/nested_menu_bar.dart';

import '../../fare_view/airport_charges/airport_charges.dart';
import '../../fare_view/fare_by_vehicle/fare_by_vehicle.dart';
import '../../fare_view/fare_charges/fare_charges.dart';
import '../../fare_view/fare_configuration_day/fare_configuration_day.dart';
import '../../fare_view/fare_increment/fare_increment.dart';
import '../../fare_view/fare_meter/fare_meter.dart';
import '../../fare_view/plot_fare/create_fixed_fare_setting.dart';
import '../../fare_view/plot_fare/plot_fare.dart';
import 'menu_actions.dart';

/// The FARES menu.
NestedMenuItem buildFaresMenu(MenuActions actions) {
  return NestedMenuItem(title: "FARES", children: [
    NestedMenuItem(
      title: "CREATE FARE SETTINGS",
      onTap: () => actions.openPage(
        title: "CREATE FARE SETTINGS",
        page: () => FareConfigurationDay(),
      ),
    ),
    NestedMenuItem(
      title: "CREATE FIXED FARE SETTINGS",
      onTap: () => actions.openPage(
        title: "CREATE FIXED FARE SETTINGS",
        page: () => CreateFixedFareSetting(),
      ),
    ),
    NestedMenuItem(
      title: "CREATE PLOT FARE",
      onTap: () => actions.openPage(
        title: "CREATE PLOT FARE",
        page: () => PlotFare(),
      ),
    ),
    NestedMenuItem(
      title: "CREATE FARE BY VEHICLE SETTINGS",
      onTap: () => actions.openPage(
        title: "CREATE FARE BY VEHICLE SETTINGS",
        page: () => FareByVehicle(),
      ),
    ),
    NestedMenuItem(
      title: "AIRPORT CHARGES",
      onTap: () => actions.openPage(
        title: "AIRPORT CHARGES",
        page: () => AirportCharges(),
      ),
    ),
    NestedMenuItem(
      title: "FARE INCREMENT",
      onTap: () => actions.openPage(
        title: "FARE INCREMENT",
        page: () => FareIncrement(),
      ),
    ),
    NestedMenuItem(
      title: "SUR CHARGES",
      onTap: () => actions.openPage(
        title: "SUR CHARGES",
        page: () => FareCharges(),
      ),
    ),
    NestedMenuItem(
      title: "FARE METER",
      onTap: () => actions.openPage(
        title: "FARE METER",
        page: () => FareMeter(),
      ),
    ),
  ]);
}
