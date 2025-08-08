

import 'package:get/get.dart';
import '../view/auth/login_screen.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../view/dashboard_view/dashboard.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.loginScreen;

  static final routes = [
    GetPage(
      name: _Paths.loginScreen,
      page: () => LoginScreen(),
      // binding: DashBoardBinding(),
    ),
    GetPage(
      name: _Paths.dashBoarScreen,
      page: () => DashBoarScreen(),
      binding: DashBoardBindings(),
    ),
  ];
}