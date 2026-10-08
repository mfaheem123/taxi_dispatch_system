import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_menu_item.dart';

import '../../vehicles_view/company_vehiclesScreen.dart';
import '../../vehicles_view/controller/controller.dart';
import '../../vehicles_view/create_company_vehicle.dart';
import '../../vehicles_view/create_vehicle_types.dart';
import '../../vehicles_view/list_vehicle_type.dart';
import 'menu_actions.dart';

/// The VEHICLES menu.
AppMenuItem buildVehiclesMenu(MenuActions actions) {
  /// Wipes whatever the vehicle forms were left holding, so a fresh entry opens
  /// on an empty form.
  void resetVehicleForm(void Function(VehicleController) reset) {
    if (Get.isRegistered<VehicleController>()) {
      reset(Get.find<VehicleController>());
    }
  }

  return AppMenuItem(title: "VEHICLES", icon: Icons.directions_car, children: [
    AppMenuItem(
      title: "CREATE VEHICLE TYPE",
      onTap: () => actions.openPage(
        title: "CREATE VEHICLE TYPE",
        page: () => CreateVehicleTypes(),
        permission: 'create_vehicle_type',
        beforeOpen: () => resetVehicleForm((c) => c.clearForm()),
      ),
    ),
    AppMenuItem(
      title: "VEHICLE TYPE",
      onTap: () => actions.openPage(
        title: "VEHICLE TYPE",
        page: () => ListVehicleType(),
        permission: 'read_vehicle_type',
      ),
    ),
    AppMenuItem(
      title: "CREATE COMPANY VEHICLE",
      onTap: () => actions.openPage(
        title: "CREATE COMPANY VEHICLE",
        page: () => CreateCompanyVehicle(),
        permission: 'create_company_vehicle',
        beforeOpen: () => resetVehicleForm((c) => c.clearCompanyVehicleForm()),
      ),
    ),
    AppMenuItem(
      title: "COMPANY VEHICLES LIST",
      onTap: () => actions.openPage(
        title: "COMPANY VEHICLES LIST",
        page: () => CompanyVehiclesScreen(),
        permission: 'read_company_vehicle',
      ),
    ),
  ]);
}
