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
  static const CompleteBookingsScreen = _Paths.CompleteBookingsScreen;
  static const CustomerFormScreen = _Paths.CustomerFormScreen;
}

abstract class _Paths {
  static const myHomePage = '/MyHomePage';
  static const loginScreen = '/LoginScreen';
  static const dashBoarScreen = '/DashBoarScreen';
  static const createBooking = '/CreateBooking';
  static const viewDriversMap = '/ViewDriversMap';
  static const createVehicle = '/ViewDriversMap';
  static const ResponsivePassengerScreen = '/ResponsivePassengerScreen';
  static const CompleteBookingsScreen = '/CompleteBookingsScreen';
  static const CustomerFormScreen = '/CustomerFormScreen';
}