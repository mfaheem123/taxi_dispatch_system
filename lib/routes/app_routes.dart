part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const loginScreen = _Paths.loginScreen;
  static const dashBoarScreen = _Paths.dashBoarScreen;
  static const createBooking = _Paths.createBooking;
  static const viewDriversMap = _Paths.viewDriversMap;
  static const createVehicle = _Paths.createVehicle;
  static const ResponsivePassengerScreen = _Paths.ResponsivePassengerScreen;
}

abstract class _Paths {
  static const loginScreen = '/LoginScreen';
  static const dashBoarScreen = '/DashBoarScreen';
  static const createBooking = '/CreateBooking';
  static const viewDriversMap = '/ViewDriversMap';
  static const createVehicle = '/ViewDriversMap';
  static const ResponsivePassengerScreen = '/ResponsivePassengerScreen';
}