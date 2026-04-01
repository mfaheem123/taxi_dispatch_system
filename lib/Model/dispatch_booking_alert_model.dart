// To parse this JSON data, do
//
//     final dispatchBookingModel = dispatchBookingModelFromJson(jsonString);

import 'dart:convert';

DispatchBookingModel dispatchBookingModelFromJson(String str) => DispatchBookingModel.fromJson(json.decode(str));

String dispatchBookingModelToJson(DispatchBookingModel data) => json.encode(data.toJson());

class DispatchBookingModel {
  bool? status;
  List<LoginDriver>? loginDrivers;
  List<dynamic>? busyDrivers;

  DispatchBookingModel({
    this.status,
    this.loginDrivers,
    this.busyDrivers,
  });

  factory DispatchBookingModel.fromJson(Map<String, dynamic> json) => DispatchBookingModel(
    status: json["status"],
    loginDrivers: json["login_drivers"] == null ? [] : List<LoginDriver>.from(json["login_drivers"]!.map((x) => LoginDriver.fromJson(x))),
    busyDrivers: json["busy_drivers"] == null ? [] : List<dynamic>.from(json["busy_drivers"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "login_drivers": loginDrivers == null ? [] : List<dynamic>.from(loginDrivers!.map((x) => x.toJson())),
    "busy_drivers": busyDrivers == null ? [] : List<dynamic>.from(busyDrivers!.map((x) => x)),
  };
}

class LoginDriver {
  int? id;
  String? name;
  String? username;
  dynamic zone;
  String? lastLoginAt;
  String? vehicleType;

  LoginDriver({
    this.id,
    this.name,
    this.username,
    this.zone,
    this.lastLoginAt,
    this.vehicleType,
  });

  factory LoginDriver.fromJson(Map<String, dynamic> json) => LoginDriver(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    zone: json["zone"],
    lastLoginAt: json["last_login_at"],
    vehicleType: json["vehicle_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "zone": zone,
    "last_login_at": lastLoginAt,
    "vehicle_type": vehicleType,
  };
}
