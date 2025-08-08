part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const loginScreen = _Paths.loginScreen;
  static const dashBoarScreen = _Paths.dashBoarScreen;
}

abstract class _Paths {
  static const loginScreen = '/LoginScreen';
  static const dashBoarScreen = '/DashBoarScreen';
}