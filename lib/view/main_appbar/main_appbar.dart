import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'menu/app_menu_item.dart';

import '../../component/color.dart';
import '../auth/Controller/auth_controller.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/dashboard/defult_dashboard_view.dart';
import '../setting/chat_with_driver_passenger.dart';
import 'components/main_appbar_header.dart';
import 'components/main_bottom_bar.dart';
import 'components/mobile_shell.dart';
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
  late final List<AppMenuItem> hoverMenu;

  /// Shared by the menu bar (web) and the drawer (phone).
  late final MenuActions _menuActions;

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
    _menuActions = MenuActions(
      controller: controller,
      refresh: (change) => setState(change),
    );
    hoverMenu = buildMainMenu(context, _menuActions);
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
    // Phone: no hover menu bar — a slim app bar and a drawer instead.
    final isMobile = isMobileShell(context);
    return PopScope(
      canPop: false,
      // Har tap yahan note hota hai, taake baad mein pata chale k focus user ne
      // di hai ya widget ne khud le li.
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _keyboard.handlePointerDown,
        child: Scaffold(
          backgroundColor: DynamicColors.whiteClr,
          appBar: isMobile
              ? const MobileAppbarHeader()
              : MainAppbarHeader(menus: hoverMenu, onLogout: _logout),
          drawer: isMobile
              ? MainMobileDrawer(actions: _menuActions, onLogout: _logout)
              : null,
          body: GetBuilder<DashboardController>(builder: (controller) {
            return Stack(
              alignment: Alignment.bottomCenter,
              // Fill the whole body: by default a Stack is only as tall as the
              // page content, so on a short page the chat panel's bottom: 0
              // sat at the end of the content, leaving a gap above the
              // bottom bar.
              fit: StackFit.expand,
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
                // Driver / passenger chat, docked to the bottom-right corner
                // over the page (just above the bottom bar) while MESSAGES is
                // on. At least 680px wide: narrower than ~664px the chat
                // widget switches to its stacked phone layout, which does not
                // fit a side panel. Taller content scrolls inside the panel.
                // Desktop only: on a phone MESSAGES opens full screen from
                // MobileStatusScreen instead.
                Obx(() => messagesShow.value && !isMobile
                    ? Positioned(
                  bottom: 0,
                  right: 0,
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  width: (MediaQuery.sizeOf(context).width * 0.4)
                      .clamp(680.0, MediaQuery.sizeOf(context).width),
                  child: const Material(
                    elevation: 12,
                    color: Colors.white,
                    child: ChatWithDriverAndPassenger(),
                  ),
                )
                    : const SizedBox.shrink()),
              ],
            );
          }),
          // Phone: the status bar's contents live on MobileStatusScreen
          // (drawer > MY STATUS) instead.
          bottomNavigationBar: isMobile ? null : MainBottomBar(),
        ),
      ),
    );
  }
}