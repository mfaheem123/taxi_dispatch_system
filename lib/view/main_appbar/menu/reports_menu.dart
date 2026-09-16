import 'package:nested_menu_bar/nested_menu_bar.dart';

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
NestedMenuItem buildReportsMenu(MenuActions actions) {
  return NestedMenuItem(title: "REPORTS", children: [
    NestedMenuItem(title: "DRIVER", children: [
      NestedMenuItem(
        title: "LOGIN",
        onTap: () => actions.openPage(
          title: "LOGIN",
          page: () => DriverLoginScreen(),
        ),
      ),
      NestedMenuItem(
        title: "LOG",
        onTap: () => actions.openPage(
          title: "LOG",
          page: () => DriverLogsScreen(),
        ),
      ),
      NestedMenuItem(
        title: "EARNINGS & INFO",
        onTap: () => actions.openPage(
          title: "EARNINGS & INFO",
          page: () => EarningAndInfoScreen(),
        ),
      ),
      NestedMenuItem(
        title: "FEEDBACK",
        onTap: () => actions.openPage(
          title: "FEEDBACK",
          page: () => ReportFeedback(),
        ),
      ),
    ]),
    NestedMenuItem(title: "BOOKINGS", children: [
      NestedMenuItem(
        title: "ALL BOOKINGS",
        onTap: () => actions.openPage(
          title: "ALL BOOKINGS",
          page: () => AllBookingView(),
        ),
      ),
      NestedMenuItem(
        title: "TRANSFERED BOOKINGS",
        onTap: () => actions.openPage(
          title: "TRANSFERED BOOKINGS",
          page: () => ReportTransferedBooking(),
        ),
      ),
    ]),
    NestedMenuItem(title: "EMPLOYEE", children: [
      NestedMenuItem(
        title: "ACTIVITY",
        onTap: () => actions.openPage(
          title: "ACTIVITY",
          page: () => ActivityScreen(),
        ),
      ),
    ]),
    NestedMenuItem(title: "INCOME", children: [
      NestedMenuItem(
        title: "INCOME",
        onTap: () => actions.openPage(
          title: "INCOME",
          page: () => IncomeScreen(),
        ),
      ),
      NestedMenuItem(
        title: "COMPANY INCOME",
        onTap: () => actions.openPage(
          title: "COMPANY INCOME",
          page: () => CompanyIncomeScreen(),
        ),
      ),
      NestedMenuItem(
        title: "CREDIT CARD PAYMENTS",
        onTap: () => actions.openPage(
          title: "CREDIT CARD PAYMENTS",
          page: () => CreiditCardPayments(),
        ),
      ),
    ]),
    NestedMenuItem(
      title: "PCO",
      onTap: () => actions.openPage(
        title: "PCO",
        page: () => PcoScreen(),
      ),
    ),
  ]);
}
