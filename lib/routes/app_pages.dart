import 'package:dashboard_new1/view/vehicles_view/create_vehicleScreen.dart';
import 'package:dashboard_new1/view/vehicles_view/create_vehicle_types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../view/auth/login_screen.dart';
import '../view/booking_view/complete_bookingview.dart';
import '../view/booking_view/update_booking.dart';
import '../view/cli_Screen.dart';
import '../view/customer/add_customerScreen.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../view/booking_view/craate_booking.dart';
import '../view/dashboard_view/dashboard.dart';
import '../view/dashboard_view/widgets/view_drivers_map.dart';
import '../view/drivers_view/driver/create_driver_form/Aduit_report_screen.dart';
import '../view/main_appbar/main_appbar.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.loginScreen;
  // static const initial = Routes.ResponsivePassengerScreen;
  // static const initial = Routes.createBooking;

  static final routes = [
    GetPage(
      name: _Paths.myHomePage,
      page: () => MyHomePage(),
      // binding: DashBoardBindings(),
    ),
    GetPage(
      name: _Paths.loginScreen,
      page: () => LoginScreen(),
      // binding: DashBoardBindings(),
    ),
    // GetPage(
    //   name: _Paths.ResponsivePassengerScreen,
    //   page: () => ResponsivePassengerScreen(),
    //   // binding: DashBoardBindings(),
    // ),
    GetPage(
      name: _Paths.completeBookingsScreen,
      page: () => CompleteBookingsScreen(),
      // binding: DashBoardBindings(),
    ),
    GetPage(
      name: _Paths.dashBoarScreen,
      page: () => DashBoarScreen(),
      binding: DashBoardBindings(),
    ),
    GetPage(
      name: _Paths.createBooking,
      page: () => CreateBooking(),
      binding: DashBoardBindings(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.updateBooking,
      page: () => UpdateBooking(),
      binding: DashBoardBindings(),
    ),
    GetPage(
      name: _Paths.CustomerFormScreen,
      page: () => CustomerFormScreen(),
    ),
    GetPage(
      name: _Paths.viewDriversMap,
      page: () => ViewDriversMap(),
      binding: DashBoardBindings(),
    ),
    GetPage(
      name: _Paths.createVehicle,
      page: () => CreateVehicleTypes(),
    ),
    GetPage(
      name: _Paths.driverAuditReport,
      page: () => AuditReportScreen(),
    ),
  ];
}





class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final token = GetStorage().read('token');

    if (token == null) {
      return const RouteSettings(name: Routes.loginScreen);
    }
    return null;
  }

}
