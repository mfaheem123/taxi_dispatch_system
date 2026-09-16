import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../alert/cli_extention_alert.dart';
import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../administration/model/user_model.dart';
import '../../auth/Controller/auth_controller.dart';

/// The status bar along the bottom of the shell: who is logged in, the brand
/// line, and the clock next to the operator's extension.
///
/// The clock is redrawn by the shell's one-second rebuild, so this widget is
/// deliberately built without `const` — a const instance would be reused
/// untouched and the time would sit still.
class MainBottomBar extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MainBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (auth) {
        return Container(
          width: double.infinity, // Kisi bhi screen par full width le ga
          height: 60,
          color: DynamicColors.whiteClr,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            // Content ko corners me push karega
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LoggedInUserBadge(),
              const Spacer(),
              Text(
                "NEXUS © 2026",
                style:
                    mozillaTextRegularText(color: Colors.grey, fontSize: 12),
              ),
              const Spacer(),
              _ClockAndExtension(),
            ],
          ),
        );
      },
    );
  }
}

/// The signed-in operator's username.
///
/// Not a const widget on purpose: a const instance is reused as-is on rebuild,
/// so the name would never follow a change of user.
class _LoggedInUserBadge extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _LoggedInUserBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F2EF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFC4D9D4), width: 1),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 5,
                backgroundColor: Color(0xff424899),
              ),
              const SizedBox(width: 10),
              Text(
                Employee.selectedEmployee?.username?.toUpperCase() ?? "GUEST",
                style: mozillaTextRegularText(
                    color: const Color(0xFF4A4A4A),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}

/// Today's date, the running clock, and the extension the operator is on.
///
/// Not a const widget on purpose — see [MainBottomBar]; a const instance would
/// freeze the clock.
class _ClockAndExtension extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ClockAndExtension();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat("EEE, MMM dd yyyy").format(now).toUpperCase(),
          style: mozillaTextRegularText(
              color: const Color(0xFF4A4A4A),
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
        const Text("|", style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(width: 12),
        Text(
          DateFormat("hh:mm:ss a").format(now),
          style: mozillaTextRegularText(
              color: const Color(0xFF4A4A4A),
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16), // Thoda gap extension se pehle
        GestureDetector(
          onTap: () {
            ExtensionAlert.show();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text(
                  "# ",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  Employee.selectedEmployee?.extensionNumber ?? "---",
                  style: mozillaTextRegularText(
                      color: const Color(0xff424899),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
