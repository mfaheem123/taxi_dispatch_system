

import 'package:dashboard_new1/view/vehicles_view/vehicle/create_vehicleScreen.dart';
import 'package:get/get.dart';
import '../view/auth/login_screen.dart';
import '../view/cli_Screen.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../view/dashboard_view/craate_booking.dart';
import '../view/dashboard_view/dashboard.dart';
import '../view/dashboard_view/widgets/view_drivers_map.dart';
import '../view/main_appbar/main_appbar.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();


  static const initial = Routes.loginScreen;
  // static const initial = Routes.myHomePage;

  static final routes = [
    GetPage(
      name: _Paths.myHomePage,
      page: () => MyHomePage(),
    ),
    GetPage(
      name: _Paths.loginScreen,
      page: () => LoginScreen(),
      binding: DashBoardBindings(),
    ),
    GetPage(
      name: _Paths.ResponsivePassengerScreen,
      page: () => ResponsivePassengerScreen(),
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
    ),
    GetPage(
      name: _Paths.viewDriversMap,
      page: () => ViewDriversMap(),
    ),
    GetPage(
      name: _Paths.createVehicle,
      page: () => CreateVehicle(),
    ),
  ];
}