

abstract class BaseConfig {
  String get apiUrl;
  String get imageUrl;
  String get baseUrl;
  String get socketUrl;
  String get slashImageUrl;
}

class DevConfig implements BaseConfig {
  @override
  // String get baseUrl => "http://192.168.110.5:5000/api/";
  String get baseUrl => "https://www.nexustechnologys.com/api/";
  // String get baseUrl => "http://158.220.92.206:5000/api/";


  @override
  String get imageUrl => "https://bloodlines.gologonow.app";

  @override
  String get slashImageUrl => "https://bloodlines.gologonow.app/";

  @override
  // String get apiUrl => "http://192.168.110.5:5000/api/";
  String get apiUrl => "https://www.nexustechnologys.com/api/";
  // String get apiUrl => "http://158.220.92.206:5000/api/";

  @override
  // String get socketUrl => "ws://192.168.5.251:8086/com";
String get socketUrl => "wss://www.nexustechnologys.com/websocket";

}

class ProductionConfig implements BaseConfig {
  @override
  // String get baseUrl => "http://192.168.110.5:5000/api/";
  // String get baseUrl => "https://www.nexustechnologys.com/api/";
  String get baseUrl => "http://158.220.92.206:5000/api/";

  @override
  String get imageUrl => "http://apis.bloodlines.info/public";

  @override
  String get slashImageUrl => "http://apis.bloodlines.info/public";

  @override
  // String get apiUrl => "http://192.168.110.5:5000/api/";
  // String get apiUrl => "https://www.nexustechnologys.com/api/";
  String get apiUrl => "http://158.220.92.206:5000/api/";

  @override
  // String get socketUrl => "ws://192.168.110.5:5000/websocket";
  // String get socketUrl => "wss://www.nexustechnologys.com/websocket";
  String get socketUrl => "ws://158.220.92.206:5000/websocket";


// String get mapKey => "AIzaSyDLtchj3AddQGK3mlMgqA6HKbLQlEkEa38";
}
//flutter run --dart-define=ENVIRONMENT=dev

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String dev = 'dev';
  static const String production = 'production'; 

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.production:
        return ProductionConfig();
      default:
        return ProductionConfig();
    }
  }
}