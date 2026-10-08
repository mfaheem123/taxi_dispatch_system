import 'package:flutter/material.dart';
import 'app_menu_item.dart';

import '../../reports/driver_booking_view/all_booking_view.dart';
import '../../reports/driver_booking_view/report_transfered_booking.dart';
import '../../reports/driver_reports_view/driver_login_screen.dart';
import '../../reports/driver_reports_view/driver_logs_screen.dart';
import '../../reports/driver_reports_view/earning_and_info_screen/earning_and_info_screen.dart';
import '../../reports/driver_reports_view/report_feedback.dart';
import '../../reports/employee_reports_view/activity_screen.dart';
import '../../reports/income_report_view/company_income_screen.dart';
import '../../reports/income_report_view/creidit_card_payments.dart';
import '../../reports/income_report_view/income_screen.dart';
import '../../reports/pco_view/pco_screen.dart';
import 'menu_actions.dart';

/// The REPORTS menu, with its DRIVER / BOOKINGS / EMPLOYEE / INCOME sub-menus.
AppMenuItem buildReportsMenu(MenuActions actions) {
  return AppMenuItem(title: "REPORTS", icon: Icons.assessment, children: [
    AppMenuItem(title: "DRIVER", children: [
      AppMenuItem(
        title: "LOGIN",
        onTap: () => actions.openPage(
          title: "LOGIN",
          page: () => DriverLoginScreen(),
        ),
      ),
      AppMenuItem(
        title: "LOG",
        onTap: () => actions.openPage(
          title: "LOG",
          page: () => DriverLogsScreen(),
        ),
      ),
      AppMenuItem(
        title: "EARNINGS & INFO",
        onTap: () => actions.openPage(
          title: "EARNINGS & INFO",
          page: () => EarningAndInfoScreen(),
        ),
      ),
      AppMenuItem(
        title: "FEEDBACK",
        onTap: () => actions.openPage(
          title: "FEEDBACK",
          page: () => ReportFeedback(),
        ),
      ),
    ]),
    AppMenuItem(title: "BOOKINGS", children: [
      AppMenuItem(
        title: "ALL BOOKINGS",
        onTap: () => actions.openPage(
          title: "ALL BOOKINGS",
          page: () => AllBookingView(),
        ),
      ),
      AppMenuItem(
        title: "TRANSFERED BOOKINGS",
        onTap: () => actions.openPage(
          title: "TRANSFERED BOOKINGS",
          page: () => ReportTransferedBooking(),
        ),
      ),
    ]),
    AppMenuItem(title: "EMPLOYEE", children: [
      AppMenuItem(
        title: "ACTIVITY",
        onTap: () => actions.openPage(
          title: "ACTIVITY",
          page: () => ActivityScreen(),
        ),
      ),
    ]),
    AppMenuItem(title: "INCOME", children: [
      AppMenuItem(
        title: "INCOME",
        onTap: () => actions.openPage(
          title: "INCOME",
          page: () => IncomeScreen(),
        ),
      ),
      AppMenuItem(
        title: "COMPANY INCOME",
        onTap: () => actions.openPage(
          title: "COMPANY INCOME",
          page: () => CompanyIncomeScreen(),
        ),
      ),
      AppMenuItem(
        title: "CREDIT CARD PAYMENTS",
        onTap: () => actions.openPage(
          title: "CREDIT CARD PAYMENTS",
          page: () => CreiditCardPayments(),
        ),
      ),
    ]),
    AppMenuItem(
      title: "PCO",
      onTap: () => actions.openPage(
        title: "PCO",
        page: () => PcoScreen(),
      ),
    ),
  ]);
}
