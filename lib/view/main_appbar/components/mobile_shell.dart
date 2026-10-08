import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../alert/cli_extention_alert.dart';
import '../../../component/color.dart';
import '../../booking_view/create_new_booking_form.dart';
import '../menu/menu_actions.dart';
import 'mobile_status_screen.dart';

/// Below this width the shell drops the hover menu bar for [MobileAppbarHeader]
/// and [MainMobileDrawer]. Same phone breakpoint as the booking form.
const double kMobileShellBreakpoint = 640;

bool isMobileShell(BuildContext context) =>
    MediaQuery.sizeOf(context).width < kMobileShellBreakpoint;

/// The phone app bar: the menu (drawer) button and the brand logo. The hover
/// menu bar and the action icons move into [MainMobileDrawer].
class MobileAppbarHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const MobileAppbarHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: DynamicColors.primaryClr,
      iconTheme: IconThemeData(color: DynamicColors.whiteClr),
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Image.asset(
          'assets/cabflow_logo.png',
          height: 24,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

/// The phone drawer: CREATE BOOKING, then the same actions as the icon row at
/// the right end of the web app bar (extension, alerts, log out).
class MainMobileDrawer extends StatelessWidget {
  const MainMobileDrawer({
    super.key,
    required this.actions,
    required this.onLogout,
  });

  final MenuActions actions;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    void closeThen(VoidCallback action) {
      Navigator.of(context).pop();
      action();
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: DynamicColors.primaryClr,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image.asset('assets/cabflow_logo.png', height: 28),
              ),
            ),
            _item(
              Icons.add_circle_outline,
              'CREATE BOOKING',
              () => closeThen(() {
                // Same as the menu bar's BOOKINGS > CREATE BOOKINGS.
                if (!actions.canOpenAnotherPage) actions.showLimitReached();
                Get.to(() => const CreateNewBookingForm());
              }),
            ),
            // No action behind the bell on the web app bar either.
            _item(Icons.notifications, 'NOTIFICATIONS',
                () => Navigator.of(context).pop()),
            const Spacer(),
            const Divider(height: 1),
            _item(
              Icons.power_settings_new,
              'LOG OUT',
              () => closeThen(onLogout),
              color: const Color(0xFFD32F2F),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    final c = color ?? DynamicColors.primaryClr;
    return ListTile(
      leading: Icon(icon, color: c),
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 14, color: color),
      ),
      onTap: onTap,
    );
  }
}
