import 'package:nested_menu_bar/nested_menu_bar.dart';

import '../../drivers_view/driver/bulk_driver_commission/bulk_driver_commission.dart';
import '../../drivers_view/driver/bulk_driver_commission/bulk_driver_rent.dart';
import '../../drivers_view/driver/create_driver_form/driver_form.dart';
import '../../drivers_view/driver/driver_app_features/driver_app_feature_screen.dart';
import '../../drivers_view/driver/driver_commission/create_driver_commission.dart';
import '../../drivers_view/driver/driver_commission/create_driver_rent.dart';
import '../../drivers_view/driver/driver_commission/list_driver_commission.dart';
import '../../drivers_view/driver/driver_commission/list_driver_rent.dart';
import '../../drivers_view/driver/driver_commission_pay/driver_commission_pay.dart';
import '../../drivers_view/driver/driver_rent_pay/driver_rent_pay.dart';
import '../../drivers_view/driver/driver_sin_bin_setting/driver_sin_bin_setting.dart';
import '../../drivers_view/driver/drivers_list/driver_list_screen.dart';
import '../../drivers_view/driver/login_drivers/login_drivers_screen.dart';
import 'menu_actions.dart';

/// The DRIVERS menu, with its DRIVER / COMMISSION / RENT sub-menus.
NestedMenuItem buildDriversMenu(MenuActions actions) {
  return NestedMenuItem(title: "DRIVERS", children: [
    NestedMenuItem(
      title: "DRIVER",
      children: [
        NestedMenuItem(
          title: "ADD DRIVER",
          onTap: () => actions.openPage(
            title: "ADD DRIVER",
            page: () => DriverForm(),
            permission: 'create_driver',
          ),
        ),
        NestedMenuItem(
          title: "DRIVERS",
          onTap: () => actions.openPage(
            title: "DRIVERS",
            page: () => DriverListScreen(),
            permission: 'read_driver',
          ),
        ),
        NestedMenuItem(
          title: "LIST OF LOGGED IN/OUT DRIVERS",
          onTap: () => actions.openPage(
            title: "LIST OF LOGGED IN/OUT DRIVERS",
            page: () => LoginDriversScreen(),
          ),
        ),
      ],
    ),
    NestedMenuItem(
      title: "DRIVER COMMISSION",
      children: [
        NestedMenuItem(
          title: "CREATE DRIVER COMMISSION",
          onTap: () => actions.openPage(
            title: "CREATE DRIVER COMMISSION",
            page: () => ListDriverCommission(),
            permission: 'create_driver_commission',
          ),
        ),
        NestedMenuItem(
          title: "DRIVER COMMISSIONS",
          onTap: () => actions.openPage(
            title: "DRIVER COMMISSIONS",
            page: () => DriverCommission(),
            permission: 'read_driver_commission',
          ),
        ),
        NestedMenuItem(
          title: "BULK DRIVER COMMISSION",
          onTap: () => actions.openPage(
            title: "BULK DRIVER COMMISSION",
            page: () => BulkDriverCommission(),
          ),
        ),
        NestedMenuItem(
          title: "DRIVER COMMISSION PAY",
          onTap: () => actions.openPage(
            title: "DRIVER COMMISSION PAY",
            page: () => DriverCommissionPay(),
          ),
        ),
      ],
    ),
    NestedMenuItem(
      title: "DRIVER RENT",
      children: [
        NestedMenuItem(
          title: "CREATE DRIVER RENT",
          onTap: () => actions.openPage(
            title: "CREATE DRIVER RENT",
            page: () => CreateDriverRent(),
          ),
        ),
        NestedMenuItem(
          title: "DRIVER RENT",
          onTap: () => actions.openPage(
            title: "DRIVER RENT",
            page: () => DriverRent(),
          ),
        ),
        NestedMenuItem(
          title: "BULK DRIVER RENT",
          onTap: () => actions.openPage(
            title: "BULK DRIVER RENT",
            page: () => BulkDriverRent(),
          ),
        ),
        NestedMenuItem(
          title: "DRIVER RENT PAY",
          onTap: () => actions.openPage(
            title: "DRIVER RENT PAY",
            page: () => DriverRentPay(),
          ),
        ),
      ],
    ),
    NestedMenuItem(
      title: "DRIVER APP FEATURES",
      onTap: () => actions.openPage(
        title: "DRIVER APP FEATURES",
        page: () => DriverAppFeatureScreen(),
        permission: 'read_app_feature',
      ),
    ),
    NestedMenuItem(
      title: "DRIVER SIN BIN SETTINGS",
      onTap: () => actions.openPage(
        title: "DRIVER SIN BIN SETTINGS",
        page: () => DriverSinBinSetting(),
      ),
    ),
  ]);
}
