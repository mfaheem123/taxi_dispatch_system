import 'package:flutter/material.dart';
import 'package:nested_menu_bar/nested_menu_bar.dart';

import '../../../alert/back_slash_alert.dart';
import '../../setting/booking_clearing_utility_screen.dart';
import '../../setting/call_recordings.dart';
import '../../setting/chat_with_driver_passenger.dart';
import '../../setting/company_configuration_view/company_configuration_view.dart';
import '../../setting/company_information_screen.dart';
import '../../setting/document_number_screen.dart';
import '../../setting/email_tracking.dart';
import '../../setting/location_type_shortcuts.dart';
import '../../setting/payment_types_color.dart';
import '../../setting/sms_tracking.dart';
import '../../setting/template_settings.dart';
import '../../setting/voipSetting_Screen.dart';
import '../../setting/wallboard_screen.dart';
import 'menu_actions.dart';

/// The SETTINGS menu.
///
/// [context] is what the two dialog entries are opened from.
NestedMenuItem buildSettingsMenu(BuildContext context, MenuActions actions) {
  return NestedMenuItem(title: "SETTINGS", children: [
    NestedMenuItem(
      title: "COMPANY INFORMATION",
      onTap: () => actions.openPage(
        title: "COMPANY INFORMATION",
        page: () => ComapanyInformationScreen(),
        permission: 'read_company_information',
      ),
    ),
    NestedMenuItem(
      title: "COMPANY CONFIGURATION",
      onTap: () => actions.openPage(
        title: "COMPANY CONFIGURATION",
        page: () => CompanyConfigurationView(),
        permission: 'read_company_configuration',
      ),
    ),
    NestedMenuItem(
      title: "PAYMENT TYPES COLOR CODE",
      onTap: () => actions.openDialog(
        context: context,
        title: "PAYMENT TYPES COLOR CODE",
        builder: (_) => const PaymentTypeDialog(),
      ),
    ),
    NestedMenuItem(
      title: "DOCUMENT NUMBER",
      onTap: () => actions.openPage(
        title: "DOCUMENT NUMBER",
        page: () => DocumentNumberScreen(),
        permission: 'read_document_number',
      ),
    ),
    NestedMenuItem(
      title: "TEMPLATE SETTINGS",
      onTap: () => actions.openPage(
        title: "TEMPLATE SETTINGS",
        page: () => TemplateSettings(),
        permission: 'read_template',
      ),
    ),
    NestedMenuItem(
      title: "CLEAR BOOKINGS",
      onTap: () => actions.openPage(
        title: "CLEAR BOOKINGS",
        page: () => BookingClearingUtilityScreen(),
      ),
    ),
    NestedMenuItem(
      title: "LOCATION TYPE SHORTCUTS",
      onTap: () => actions.openPage(
        title: "LOCATION TYPE SHORTCUTS",
        page: () => LocationTypeShortcuts(),
      ),
    ),
    NestedMenuItem(
      title: "VOIP SETTINGS",
      onTap: () => actions.openPage(
        title: "VOIP SETTINGS",
        page: () => VoipSettingsScreen(),
        permission: 'read_voip_settings',
      ),
    ),
    NestedMenuItem(
      title: "SMS TRACKING",
      onTap: () => actions.openPage(
        title: "SMS TRACKING",
        page: () => SmsSettingsScreen(),
      ),
    ),
    NestedMenuItem(
      title: "EMAIL TRACKING",
      onTap: () => actions.openPage(
        title: "EMAIL TRACKING",
        page: () => EmailTrackingScreen(),
      ),
    ),
    NestedMenuItem(
      title: "CALL RECORDINGS",
      onTap: () => actions.openPage(
        title: "CALL RECORDINGS",
        page: () => CallRecordingScreen(),
      ),
    ),
    NestedMenuItem(
      title: "HELP",
      onTap: () => actions.openDialog(
        context: context,
        title: "HELP",
        builder: (_) => const BackSlashAlert(),
      ),
    ),
    NestedMenuItem(
      title: "CHAT WITH DRIVER AND PASSENGER",
      onTap: () => actions.openPage(
        title: "CHAT WITH DRIVER AND PASSENGER",
        page: () => ChatWithDriverAndPassenger(),
      ),
    ),
    NestedMenuItem(
      title: "WALLBOARD",
      onTap: () => actions.openPage(
        title: "WALLBOARD",
        page: () => WallboardScreen(),
      ),
    ),
  ]);
}
