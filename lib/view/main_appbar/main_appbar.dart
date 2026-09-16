import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nested_menu_bar/nested_menu_bar.dart';

import '../../component/color.dart';
import '../auth/Controller/auth_controller.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/dashboard/defult_dashboard_view.dart';
import 'components/main_appbar_header.dart';
import 'components/main_bottom_bar.dart';
import 'components/open_pages_tab_strip.dart';
import 'keyboard/shell_keyboard_controller.dart';
import 'menu/main_menu.dart';
import 'menu/menu_actions.dart';

/// The application shell: the menu bar on top, the strip of open pages under
/// it, whichever page is currently shown, and the status bar at the bottom.
///
/// Everything it draws lives in `components/`, the menu items in `menu/`, and
/// the keyboard and focus rules in `keyboard/`.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DashboardController controller = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  // AuthController ko yahan register karein taake error na aaye
  final AuthController authController = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController());

  /// Owns the body's scroll view and the shell's keyboard / focus rules.
  late final ShellKeyboardController _keyboard;

  /// The menu bar's items, built once — they only close over [_menuActions].
  late final List<NestedMenuItem> hoverMenu;

  /// Redraws the clock in the status bar.
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _keyboard = ShellKeyboardController(
      controller: controller,
      fallbackViewportHeight: () => MediaQuery.of(context).size.height,
    )..attach();

    authController.checkUserStatus();
    hoverMenu = buildMainMenu(
      context,
      MenuActions(
        controller: controller,
        refresh: (change) => setState(change),
      ),
    );
    controller.inItStateOFController();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _keyboard.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await authController.logout();
    controller.selectedMenuItems.clear();
    controller.currentPage.value = ByDefaultDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // Har tap yahan note hota hai, taake baad mein pata chale k focus user ne
      // di hai ya widget ne khud le li.
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _keyboard.handlePointerDown,
        child: Scaffold(
          backgroundColor: DynamicColors.whiteClr,
          appBar: MainAppbarHeader(menus: hoverMenu, onLogout: _logout),
          body: GetBuilder<DashboardController>(builder: (controller) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  controller: _keyboard.bodyScrollController,
                  child: Column(
                    children: [
                      OpenPagesTabStrip(controller: controller),
                      Obx(() =>
                          controller.currentPage.value ?? ByDefaultDashboard()),
                    ],
                  ),
                ),
              ],
            );
          }),
          bottomNavigationBar: MainBottomBar(),
        ),
      ),
    );
  }
}
