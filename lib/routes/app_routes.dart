part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const myHomePage = _Paths.myHomePage;
  static const loginScreen = _Paths.loginScreen;
  static const dashBoarScreen = _Paths.dashBoarScreen;
  static const createBooking = _Paths.createBooking;
  static const viewDriversMap = _Paths.viewDriversMap;
  static const createVehicle = _Paths.createVehicle;
  static const ResponsivePassengerScreen = _Paths.ResponsivePassengerScreen;
  static const completeBookingsScreen = _Paths.completeBookingsScreen;
  static const CustomerFormScreen = _Paths.CustomerFormScreen;
  static const updateBooking = _Paths.updateBooking;
  static const driverAuditReport = _Paths.driverAuditReport;
}

abstract class _Paths {
  static const myHomePage = '/MyHomePage';
  static const loginScreen = '/LoginScreen';
  static const dashBoarScreen = '/DashBoarScreen';
  static const createBooking = '/CreateBooking';
  static const updateBooking = '/UpdateBooking';
  static const viewDriversMap = '/ViewDriversMap';
  static const createVehicle = '/CreateVehicleTypes';
  static const ResponsivePassengerScreen = '/ResponsivePassengerScreen';
  static const completeBookingsScreen = '/CompleteBookingsScreen';
  static const CustomerFormScreen = '/CustomerFormScreen';
  static const driverAuditReport = '/view/driver_audit_report';
}