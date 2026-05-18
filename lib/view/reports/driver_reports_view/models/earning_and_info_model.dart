// To parse this JSON data, do
//
//     final earningInfoListModel = earningInfoListModelFromJson(jsonString);

import 'dart:convert';

EarningInfoListModel earningInfoListModelFromJson(String str) => EarningInfoListModel.fromJson(json.decode(str));

String earningInfoListModelToJson(EarningInfoListModel data) => json.encode(data.toJson());

class EarningInfoListModel {
  bool? success;
  String? message;
  Data? data;

  EarningInfoListModel({
    this.success,
    this.message,
    this.data,
  });

  factory EarningInfoListModel.fromJson(Map<String, dynamic> json) => EarningInfoListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? totalBookings;
  double? totalAmount;
  List<Driver>? drivers;

  Data({
    this.totalBookings,
    this.totalAmount,
    this.drivers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalBookings: json["total_bookings"],
    totalAmount: json["total_amount"]?.toDouble(),
    drivers: json["drivers"] == null ? [] : List<Driver>.from(json["drivers"]!.map((x) => Driver.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_bookings": totalBookings,
    "total_amount": totalAmount,
    "drivers": drivers == null ? [] : List<dynamic>.from(drivers!.map((x) => x.toJson())),
  };
}

class Driver {
  int? driverId;
  String? username;
  String? name;
  String? driverStatus;
  String? sessionStatus;
  String? totalBookings;
  String? totalEarnings;

  Driver({
    this.driverId,
    this.username,
    this.name,
    this.driverStatus,
    this.sessionStatus,
    this.totalBookings,
    this.totalEarnings,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    driverId: json["driver_id"],
    username: json["username"],
    name: json["name"],
    driverStatus: json["driver_status"],
    sessionStatus: json["session_status"],
    totalBookings: json["total_bookings"],
    totalEarnings: json["total_earnings"],
  );

  Map<String, dynamic> toJson() => {
    "driver_id": driverId,
    "username": username,
    "name": name,
    "driver_status": driverStatus,
    "session_status": sessionStatus,
    "total_bookings": totalBookings,
    "total_earnings": totalEarnings,
  };
}
