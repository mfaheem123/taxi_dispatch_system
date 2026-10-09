import 'dart:html' as html;

import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart';
import 'app_menu_item.dart';

import '../../../alert/back_slash_alert.dart';
import '../../setting/clearing_booking_screen.dart';
import '../../setting/call_recordings.dart';
import '../../setting/chat_with_driver_passenger.dart';
import '../../setting/company_configuration_view/company_configuration_view.dart';
import '../../setting/company_information_screen.dart';
import '../../setting/document_number_screen.dart';
import '../../setting/email_tracking.dart';
import '../../setting/location_type_shortcuts.dart';
import '../../../alert/payment_types_color_alt.dart';
import '../../setting/sms_tracking.dart';
import '../../setting/template_settings.dart';
import '../../setting/voipSetting_Screen.dart';
import '../../setting/wallboard_screen.dart';
import 'menu_actions.dart';

/// The SETTINGS menu.
///
/// [context] is what the two dialog entries are opened from.
AppMenuItem buildSettingsMenu(BuildContext context, MenuActions actions) {
  return AppMenuItem(title: "SETTINGS", icon: Icons.settings, children: [
    AppMenuItem(
      title: "COMPANY INFORMATION",
      onTap: () => actions.openPage(
        title: "COMPANY INFORMATION",
        page: () => ComapanyInformationScreen(),
        permission: 'read_company_information',
      ),
    ),
    AppMenuItem(
      title: "COMPANY CONFIGURATION",
      onTap: () => actions.openPage(
        title: "COMPANY CONFIGURATION",
        page: () => CompanyConfigurationView(),
        permission: 'read_company_configuration',
      ),
    ),
    AppMenuItem(
      title: "PAYMENT TYPES COLOR CODE",
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return const PaymentTypeDialog();
          },
        );
      },
    ),
    AppMenuItem(
      title: "DOCUMENT NUMBER",
      onTap: () => actions.openPage(
        title: "DOCUMENT NUMBER",
        page: () => DocumentNumberScreen(),
        permission: 'read_document_number',
      ),
    ),
    AppMenuItem(
      title: "TEMPLATE SETTINGS",
      onTap: () => actions.openPage(
        title: "TEMPLATE SETTINGS",
        page: () => TemplateSettings(),
        permission: 'read_template',
      ),
    ),
    AppMenuItem(
      title: "CLEAR BOOKINGS",
      onTap: () => actions.openPage(
        title: "CLEAR BOOKINGS",
        page: () => BookingClearingUtilityScreen(),
      ),
    ),
    AppMenuItem(
      title: "LOCATION TYPE SHORTCUTS",
      onTap: () => actions.openPage(
        title: "LOCATION TYPE SHORTCUTS",
        page: () => LocationTypeShortcuts(),
      ),
    ),
    AppMenuItem(
      title: "VOIP SETTINGS",
      onTap: () => actions.openPage(
        title: "VOIP SETTINGS",
        page: () => VoipSettingsScreen(),
        permission: 'read_voip_settings',
      ),
    ),
    AppMenuItem(
      title: "SMS TRACKING",
      onTap: () => actions.openPage(
        title: "SMS TRACKING",
        page: () => SmsSettingsScreen(),
      ),
    ),
    AppMenuItem(
      title: "EMAIL TRACKING",
      onTap: () => actions.openPage(
        title: "EMAIL TRACKING",
        page: () => EmailTrackingScreen(),
      ),
    ),
    AppMenuItem(
      title: "CALL RECORDINGS",
      onTap: () => actions.openPage(
        title: "CALL RECORDINGS",
        page: () => CallRecordingScreen(),
      ),
    ),
    AppMenuItem(
      title: "HELP",
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return const BackSlashAlert();
          },
        );
      },
    ),
    AppMenuItem(
      title: "CHAT WITH DRIVER AND PASSENGER",
      onTap: () => actions.openPage(
        title: "CHAT WITH DRIVER AND PASSENGER",
        page: () => ChatWithDriverAndPassenger(),
      ),
    ),
    AppMenuItem(
      title: "WALLBOARD",
      onTap: () {
        final newTabUrl = Uri.base.origin + '/#' + Routes.wallboardScreen;
        html.window.open(newTabUrl, '_blank');
      }
      // => actions.openPage(
      //   title: "WALLBOARD",
      //   page: () => WallboardScreen(),
      // ),
    ),
  ]);
}
