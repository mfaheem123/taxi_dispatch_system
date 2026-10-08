import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_menu_item.dart';

import '../../customer/add_customerScreen.dart';
import '../../customer/complaints.dart';
import '../../customer/controller/customer_controller.dart';
import '../../customer/create_complaint.dart';
import '../../customer/create_lost_propertyScreen.dart';
import '../../customer/customers_screen.dart';
import '../../customer/lost_property.dart';
import 'menu_actions.dart';

/// The CUSTOMERS menu.
AppMenuItem buildCustomersMenu(MenuActions actions) {
  /// Wipes whatever the customer forms were left holding, so a fresh entry
  /// opens on an empty form.
  void resetCustomerForm(void Function(CustomerController) reset) {
    if (Get.isRegistered<CustomerController>()) {
      reset(Get.find<CustomerController>());
    }
  }

  return AppMenuItem(title: "CUSTOMERS", icon: Icons.groups, children: [
    AppMenuItem(
      title: "ADD CUSTOMER",
      onTap: () => actions.openPage(
        title: "ADD CUSTOMER",
        page: () => CustomerFormScreen(),
        permission: 'create_customer',
        beforeOpen: () => resetCustomerForm((c) => c.clearForm()),
      ),
    ),
    AppMenuItem(
      title: "CUSTOMERS",
      onTap: () => actions.openPage(
        title: "CUSTOMERS",
        page: () => CustomersScreen(),
        permission: 'read_customer',
      ),
    ),
    AppMenuItem(
      title: "CREATE LOST PROPERTY",
      onTap: () => actions.openPage(
        title: "CREATE LOST PROPERTY",
        page: () => LostPropertyScreen(),
        permission: 'create_lost_property',
        beforeOpen: () => resetCustomerForm((c) => c.refreshFields()),
      ),
    ),
    AppMenuItem(
      title: "LOST PROPERTY",
      onTap: () => actions.openPage(
        title: "LOST PROPERTY",
        page: () => LostProperty(),
        permission: 'read_lost_property',
      ),
    ),
    AppMenuItem(
      title: "CREATE COMPLAINT",
      onTap: () => actions.openPage(
        title: "CREATE COMPLAINT",
        page: () => CreateComplaint(),
        permission: 'create_complaint',
        beforeOpen: () => resetCustomerForm((c) => c.clearComplaintForm()),
      ),
    ),
    AppMenuItem(
      title: "COMPLAINTS",
      onTap: () => actions.openPage(
        title: "COMPLAINTS",
        page: () => ComplaintsView(),
        permission: 'read_complaint',
      ),
    ),
  ]);
}
