import '../../../alert/back_slash_alert.dart';
import '../../accounts/Invoice/list_customer_invoices.dart';
import '../../accounts/account/account_view.dart';
import '../../accounts/list_of_accountScreen.dart';
import '../../administration/User/create_userScreen.dart';
import '../../administration/User/user_listScreen.dart';
import '../../booking_view/app_booking.dart';
import '../../booking_view/complete_bookingview.dart';
import '../../booking_view/multi_booking.dart';
import '../../booking_view/pending_booking.dart';
import '../../booking_view/pre_booking.dart';
import '../../booking_view/web_booking.dart';
import '../../customer/add_customerScreen.dart';
import '../../customer/complaints.dart';
import '../../customer/create_complaint.dart';
import '../../customer/create_lost_propertyScreen.dart';
import '../../customer/customers_screen.dart';
import '../../customer/lost_property.dart';
import '../../drivers_view/driver/bulk_driver_commission/bulk_driver_commission.dart';
import '../../drivers_view/driver/bulk_driver_commission/bulk_driver_rent.dart';
import '../../drivers_view/driver/create_driver_form/driver_form.dart';
import '../../drivers_view/driver/driver_app_features/driver_app_feature_screen.dart';
import '../../drivers_view/driver/driver_commission/create_driver_commission.dart';
import '../../drivers_view/driver/driver_commission/create_driver_rent.dart';
import '../../drivers_view/driver/driver_commission/list_driver_commission.dart';
import '../../drivers_view/driver/driver_commission/list_driver_rent.dart';
import '../../drivers_view/driver/driver_commission_pay/driver_commission_pay.dart';
import '../../drivers_view/driver/driver_rent_pay/driver_rent_pay.dart';
import '../../drivers_view/driver/driver_sin_bin_setting/driver_sin_bin_setting.dart';
import '../../drivers_view/driver/drivers_list/driver_list_screen.dart';
import '../../drivers_view/driver/login_drivers/login_drivers_screen.dart';
import '../../fare_view/airport_charges/airport_charges.dart';
import '../../fare_view/fare_by_vehicle/fare_by_vehicle.dart';
import '../../fare_view/fare_charges/fare_charges.dart';
import '../../fare_view/fare_configuration_day/fare_configuration_day.dart';
import '../../fare_view/fare_increment/fare_increment.dart';
import '../../fare_view/fare_meter/fare_meter.dart';
import '../../fare_view/plot_fare/create_fixed_fare_setting.dart';
import '../../fare_view/plot_fare/plot_fare.dart';
import '../../locations_view/location/localization_screen.dart';
import '../../locations_view/location/location_formScreen.dart';
import '../../locations_view/location/location_listScreen.dart';
import '../../locations_view/location/zone_listScreen.dart';
import '../../locations_view/location/zone_screen.dart';
import '../../reports/driver_booking_view/all_booking_view.dart';
import '../../reports/driver_booking_view/report_transfered_booking.dart';
import '../../reports/driver_reports_view/driver_login_screen.dart';
import '../../reports/driver_reports_view/driver_logs_screen.dart';
import '../../reports/driver_reports_view/earning_and_info_screen/earning_and_info_screen.dart';
import '../../reports/driver_reports_view/report_feedback.dart';
import '../../reports/driver_reports_view/statistics_screen.dart';
import '../../reports/employee_reports_view/activity_screen.dart';
import '../../reports/income_report_view/company_income_screen.dart';
import '../../reports/income_report_view/creidit_card_payments.dart';
import '../../reports/income_report_view/income_screen.dart';
import '../../reports/pco_view/pco_screen.dart';
import '../../setting/call_recordings.dart';
import '../../setting/company_configuration_view/company_configuration_view.dart';
import '../../setting/email_tracking.dart';
import '../../setting/location_type_shortcuts.dart';
import '../../setting/payment_types_color.dart';
import '../../setting/sms_tracking.dart';
import '../../setting/template_settings.dart';
import '../../setting/wallboard_screen.dart';
import '../../vehicles_view/company_vehiclesScreen.dart';
import '../../vehicles_view/create_company_vehicle.dart';
import '../../vehicles_view/list_vehicle_type.dart';
import 'package:dashboard_new1/view/accounts/Invoice/create_account_invoice_screen.dart';
import 'package:dashboard_new1/view/accounts/Invoice/create_customer_invoice.dart';
import 'package:dashboard_new1/view/accounts/Invoice/list_of_account_invoice_screen.dart';
import 'package:dashboard_new1/view/accounts/create_escort_screen.dart';
import 'package:dashboard_new1/view/accounts/list_escorte_screen.dart';
import 'package:dashboard_new1/view/administration/User/create_subsiDiary.dart';
import 'package:dashboard_new1/view/administration/User/subsi_diaries_screen.dart';
import 'package:dashboard_new1/view/authorization/authorization_Screen.dart';
import 'package:dashboard_new1/view/booking_view/trash_booking.dart';
import 'package:dashboard_new1/view/setting/booking_clearing_utility_screen.dart';
import 'package:dashboard_new1/view/setting/chat_with_driver_passenger.dart';
import 'package:dashboard_new1/view/setting/company_information_screen.dart';
import 'package:dashboard_new1/view/setting/document_number_screen.dart';
import 'package:dashboard_new1/view/setting/voipSetting_Screen.dart';
import 'package:dashboard_new1/view/vehicles_view/create_vehicle_types.dart';

/// Pages the arrow keys may scroll — the list screens, which are all a plain
/// table in the shell's scroll view.
///
/// Everything else is left out on purpose: the dashboard table, the address
/// suggestion lists and the keyboard dropdowns drive their own selection with
/// the arrow keys, and the shell's listener cannot see that they already
/// handled the event.
const Set<Type> kArrowScrollPages = {
  CompleteBookingsScreen,
  PendingBooking,
  PreBooking,
  WebBooking,
  AppBooking,
  MultiBooking,
  TrashBooking,
  CustomersScreen,
  LostProperty,
  ComplaintsView,
  LostPropertyScreen,
  CustomerFormScreen,
  CreateComplaint,
  FareConfigurationDay,
  CreateFixedFareSetting,
  PlotFare,
  FareByVehicle,
  AirportCharges,
  FareIncrement,
  FareMeter,
  FareCharges,
  DriverForm,
  DriverListScreen,
  LoginDriversScreen,
  ListDriverCommission,
  DriverCommission,
  BulkDriverCommission,
  DriverCommissionPay,
  CreateDriverRent,
  DriverRent,
  BulkDriverRent,
  DriverRentPay,
  DriverAppFeatureScreen,
  DriverSinBinSetting,
  AccountView,
  ListOfAccountScreen,
  CreateEscortScreen,
  ESCORTScreen,
  CreateCustomerInvoice,
  InvoiceList,
  CreateAccountInvoiceScreen,
  ListOfAccountInvoiceScreen,
  LocationForm,
  LocationListScreen,
  ZoneScreen,
  ZoneListScreen,
  LocalizationScreen,
  CreateVehicleTypes,
  ListVehicleType,
  CreateCompanyVehicle,
  CompanyVehiclesScreen,
  CreateUserScreen,
  UserListscreen,
  CreateSubsiDiary,
  SubsiDiariesScreen,
  AuthorizationScreen,
  DriverLoginScreen,
  DriverLogsScreen,
  EarningAndInfoScreen,
  ReportFeedback,
  StatisticsScreen,
  AllBookingView,
  ReportTransferedBooking,
  ActivityScreen,
  IncomeScreen,
  CompanyIncomeScreen,
  CreiditCardPayments,
  PcoScreen,
  ComapanyInformationScreen,
  CompanyConfigurationView,
  PaymentTypeDialog,
  DocumentNumberScreen,
  TemplateSettings,
  BookingClearingUtilityScreen,
  LocationTypeShortcuts,
  VoipSettingsScreen,
  SmsSettingsScreen,
  EmailTrackingScreen,
  CallRecordingScreen,
  BackSlashAlert,
  ChatWithDriverAndPassenger,
  WallboardScreen,
};
