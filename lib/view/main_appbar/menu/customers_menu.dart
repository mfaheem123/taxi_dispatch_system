import 'package:get/get.dart';
import 'package:nested_menu_bar/nested_menu_bar.dart';

import '../../customer/add_customerScreen.dart';
import '../../customer/complaints.dart';
import '../../customer/controller/customer_controller.dart';
import '../../customer/create_complaint.dart';
import '../../customer/create_lost_propertyScreen.dart';
import '../../customer/customers_screen.dart';
import '../../customer/lost_property.dart';
import 'menu_actions.dart';

/// The CUSTOMERS menu.
NestedMenuItem buildCustomersMenu(MenuActions actions) {
  /// Wipes whatever the customer forms were left holding, so a fresh entry
  /// opens on an empty form.
  void resetCustomerForm(void Function(CustomerController) reset) {
    if (Get.isRegistered<CustomerController>()) {
      reset(Get.find<CustomerController>());
    }
  }

  return NestedMenuItem(title: "CUSTOMERS", children: [
    NestedMenuItem(
      title: "ADD CUSTOMER",
      onTap: () => actions.openPage(
        title: "ADD CUSTOMER",
        page: () => CustomerFormScreen(),
        permission: 'create_customer',
        beforeOpen: () => resetCustomerForm((c) => c.clearForm()),
      ),
    ),
    NestedMenuItem(
      title: "CUSTOMERS",
      onTap: () => actions.openPage(
        title: "CUSTOMERS",
        page: () => CustomersScreen(),
        permission: 'read_customer',
      ),
    ),
    NestedMenuItem(
      title: "CREATE LOST PROPERTY",
      onTap: () => actions.openPage(
        title: "CREATE LOST PROPERTY",
        page: () => LostPropertyScreen(),
        permission: 'create_lost_property',
        beforeOpen: () => resetCustomerForm((c) => c.refreshFields()),
      ),
    ),
    NestedMenuItem(
      title: "LOST PROPERTY",
      onTap: () => actions.openPage(
        title: "LOST PROPERTY",
        page: () => LostProperty(),
        permission: 'read_lost_property',
      ),
    ),
    NestedMenuItem(
      title: "CREATE COMPLAINT",
      onTap: () => actions.openPage(
        title: "CREATE COMPLAINT",
        page: () => CreateComplaint(),
        permission: 'create_complaint',
        beforeOpen: () => resetCustomerForm((c) => c.clearComplaintForm()),
      ),
    ),
    NestedMenuItem(
      title: "COMPLAINTS",
      onTap: () => actions.openPage(
        title: "COMPLAINTS",
        page: () => ComplaintsView(),
        permission: 'read_complaint',
      ),
    ),
  ]);
}
