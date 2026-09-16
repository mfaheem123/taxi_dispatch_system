import 'package:flutter/material.dart';

import '../../../alert/cli_extention_alert.dart';
import '../../../component/color.dart';

/// The icon row pinned to the right end of the app bar: extension, alerts and
/// log out.
class AppbarActionIcons extends StatelessWidget {
  const AppbarActionIcons({super.key, required this.onLogout});

  /// Runs when the power icon is tapped.
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            ExtensionAlert.show();
          },
          child: Icon(
            Icons.headset_mic_outlined,
            size: 24,
            color: DynamicColors.whiteClr,
          ),
        ),
        const SizedBox(width: 9),
        Icon(
          Icons.notifications,
          size: 24,
          color: DynamicColors.whiteClr,
        ),
        const SizedBox(width: 9),
        GestureDetector(
          onTap: onLogout,
          child: Icon(
            Icons.power_settings_new,
            size: 24,
            color: DynamicColors.whiteClr,
          ),
        ),
        const SizedBox(width: 9),
      ],
    );
  }
}
