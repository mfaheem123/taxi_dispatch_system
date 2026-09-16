import 'package:get/get.dart';
import 'package:nested_menu_bar/nested_menu_bar.dart';

import '../../vehicles_view/company_vehiclesScreen.dart';
import '../../vehicles_view/controller/controller.dart';
import '../../vehicles_view/create_company_vehicle.dart';
import '../../vehicles_view/create_vehicle_types.dart';
import '../../vehicles_view/list_vehicle_type.dart';
import 'menu_actions.dart';

/// The VEHICLES menu.
NestedMenuItem buildVehiclesMenu(MenuActions actions) {
  /// Wipes whatever the vehicle forms were left holding, so a fresh entry opens
  /// on an empty form.
  void resetVehicleForm(void Function(VehicleController) reset) {
    if (Get.isRegistered<VehicleController>()) {
      reset(Get.find<VehicleController>());
    }
  }

  return NestedMenuItem(title: "VEHICLES", children: [
    NestedMenuItem(
      title: "CREATE VEHICLE TYPE",
      onTap: () => actions.openPage(
        title: "CREATE VEHICLE TYPE",
        page: () => CreateVehicleTypes(),
        permission: 'create_vehicle_type',
        beforeOpen: () => resetVehicleForm((c) => c.clearForm()),
      ),
    ),
    NestedMenuItem(
      title: "VEHICLE TYPE",
      onTap: () => actions.openPage(
        title: "VEHICLE TYPE",
        page: () => ListVehicleType(),
        permission: 'read_vehicle_type',
      ),
    ),
    NestedMenuItem(
      title: "CREATE COMPANY VEHICLE",
      onTap: () => actions.openPage(
        title: "CREATE COMPANY VEHICLE",
        page: () => CreateCompanyVehicle(),
        permission: 'create_company_vehicle',
        beforeOpen: () => resetVehicleForm((c) => c.clearCompanyVehicleForm()),
      ),
    ),
    NestedMenuItem(
      title: "COMPANY VEHICLES LIST",
      onTap: () => actions.openPage(
        title: "COMPANY VEHICLES LIST",
        page: () => CompanyVehiclesScreen(),
        permission: 'read_company_vehicle',
      ),
    ),
  ]);
}
