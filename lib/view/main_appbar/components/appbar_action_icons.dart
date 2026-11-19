import 'package:flutter/material.dart';

import '../../../alert/cli_extention_alert.dart';
import '../../../component/color.dart';
import '../menu/app_menu_item.dart';

/// The icon row pinned to the right end of the web app bar — laid out like the
/// mycabify portal: theme, support headset, phone, notifications (with an
/// unread badge), settings and log out.
///
/// Web only. On mobile these actions live in the drawer / status screen, so
/// this row is not shown there.
///
/// Only the headset (extension) and power (log out) icons have an action today.
/// The theme, phone, bell and gear icons are in place to match the design and
/// are wired to no-ops — give each an `onTap` when its screen is ready.
class AppbarActionIcons extends StatelessWidget {
  const AppbarActionIcons({
    super.key,
    required this.onLogout,
    required this.settingsMenu,
    this.notificationCount = 0,
  });

  /// Runs when the power icon is tapped.
  final Future<void> Function() onLogout;

  /// The SETTINGS menu — its children are listed in the dropdown that opens
  /// under the gear icon.
  final AppMenuItem settingsMenu;

  /// Shown as the red badge on the bell. 0 hides it, >99 shows "99+".
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: DynamicColors.whiteClr.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionIcon(
            icon: Icons.dark_mode_outlined,
            tooltip: 'Theme',
            onTap: () {}, // no theme toggle yet
          ),
          _ActionIcon(
            icon: Icons.headset_mic_outlined,
            tooltip: 'Extension',
            onTap: ExtensionAlert.show,
          ),
          _ActionIcon(
            icon: Icons.call_outlined,
            tooltip: 'Phone',
            onTap: () {},
          ),
          _ActionIcon(
            icon: Icons.notifications_outlined,
            tooltip: 'Notifications',
            badgeCount: notificationCount,
            onTap: () {},
          ),
          _SettingsIconMenu(menu: settingsMenu),
          _ActionIcon(
            icon: Icons.power_settings_new,
            tooltip: 'Log out',
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

/// One tappable app-bar icon, with an optional red unread badge.
class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 22, color: DynamicColors.whiteClr),
              if (badgeCount > 0)
                Positioned(
                  right: -5,
                  top: -5,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    decoration: BoxDecoration(
                      color: DynamicColors.redClr,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The gear icon: tapping it opens a dropdown of the SETTINGS screen titles
/// (the former top-bar SETTINGS menu) under the icon.
class _SettingsIconMenu extends StatelessWidget {
  const _SettingsIconMenu({required this.menu});

  final AppMenuItem menu;

  @override
  Widget build(BuildContext context) {
    final items = menu.children ?? const <AppMenuItem>[];
    return MenuAnchor(
      style: _settingsPopupStyle,
      // Open just below the icon.
      alignmentOffset: const Offset(0, 6),
      menuChildren: [
        for (final item in items)
          MenuItemButton(
            style: _settingsItemStyle,
            onPressed: item.onTap ?? () {},
            child: Text(item.title),
          ),
      ],
      builder: (context, controller, _) {
        return Tooltip(
          message: 'Settings',
          child: InkWell(
            onTap: () =>
                controller.isOpen ? controller.close() : controller.open(),
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.settings_outlined,
                size: 22,
                color: DynamicColors.whiteClr,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// White rounded pop-up for the settings dropdown — same look as the menu bar.
const MenuStyle _settingsPopupStyle = MenuStyle(
  backgroundColor: WidgetStatePropertyAll(Colors.white),
  surfaceTintColor: WidgetStatePropertyAll(Colors.white),
  padding: WidgetStatePropertyAll(EdgeInsets.all(3)),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  ),
);

/// Entries: black on white, white on black when hovered / focused / pressed.
final ButtonStyle _settingsItemStyle = ButtonStyle(
  padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
  minimumSize: const WidgetStatePropertyAll(Size(200, 0)),
  textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 14)),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  ),
  backgroundColor: WidgetStateProperty.resolveWith(
      (s) => _settingsActive(s) ? Colors.black : Colors.white),
  foregroundColor: WidgetStateProperty.resolveWith(
      (s) => _settingsActive(s) ? Colors.white : Colors.black),
  overlayColor: const WidgetStatePropertyAll(Colors.transparent),
);

bool _settingsActive(Set<WidgetState> s) =>
    s.contains(WidgetState.hovered) ||
    s.contains(WidgetState.focused) ||
    s.contains(WidgetState.pressed);
