// To parse this JSON data, do
//
//     final driverLoginReportListModel = driverLoginReportListModelFromJson(jsonString);

import 'dart:convert';

DriverLoginReportListModel driverLoginReportListModelFromJson(String str) => DriverLoginReportListModel.fromJson(json.decode(str));

String driverLoginReportListModelToJson(DriverLoginReportListModel data) => json.encode(data.toJson());

class DriverLoginReportListModel {
  bool? status;
  List<DriverShiftHistory>? driverShiftHistories;

  DriverLoginReportListModel({
    this.status,
    this.driverShiftHistories,
  });

  factory DriverLoginReportListModel.fromJson(Map<String, dynamic> json) => DriverLoginReportListModel(
    status: json["status"],
    driverShiftHistories: json["driver_shift_histories"] == null ? [] : List<DriverShiftHistory>.from(json["driver_shift_histories"]!.map((x) => DriverShiftHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "driver_shift_histories": driverShiftHistories == null ? [] : List<dynamic>.from(driverShiftHistories!.map((x) => x.toJson())),
  };
}

class DriverShiftHistory {
  int? id;
  int? driverId;
  DateTime? loginDate;
  double? loginLatitude;
  double? loginLongitude;
  DateTime? logoutDate;
  double? logoutLatitude;
  double? logoutLongitude;
  List<int>? booking;
  String? loginTime;
  String? logoutTime;
  Driver? driver;

  DriverShiftHistory({
    this.id,
    this.driverId,
    this.loginDate,
    this.loginLatitude,
    this.loginLongitude,
    this.logoutDate,
    this.logoutLatitude,
    this.logoutLongitude,
    this.booking,
    this.loginTime,
    this.logoutTime,
    this.driver,
  });

  factory DriverShiftHistory.fromJson(Map<String, dynamic> json) => DriverShiftHistory(
    id: json["id"],
    driverId: json["driver_id"],
    loginDate: json["login_date"] == null ? null : DateTime.parse(json["login_date"]),
    loginLatitude: json["login_latitude"]?.toDouble(),
    loginLongitude: json["login_longitude"]?.toDouble(),
    logoutDate: json["logout_date"] == null ? null : DateTime.parse(json["logout_date"]),
    logoutLatitude: json["logout_latitude"]?.toDouble(),
    logoutLongitude: json["logout_longitude"]?.toDouble(),
    booking: json["booking"] == null ? [] : List<int>.from(json["booking"]!.map((x) => x)),
    loginTime: json["login_time"],
    logoutTime: json["logout_time"],
    driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_id": driverId,
    "login_date": "${loginDate!.year.toString().padLeft(4, '0')}-${loginDate!.month.toString().padLeft(2, '0')}-${loginDate!.day.toString().padLeft(2, '0')}",
    "login_latitude": loginLatitude,
    "login_longitude": loginLongitude,
    "logout_date": "${logoutDate!.year.toString().padLeft(4, '0')}-${logoutDate!.month.toString().padLeft(2, '0')}-${logoutDate!.day.toString().padLeft(2, '0')}",
    "logout_latitude": logoutLatitude,
    "logout_longitude": logoutLongitude,
    "booking": booking == null ? [] : List<dynamic>.from(booking!.map((x) => x)),
    "login_time": loginTime,
    "logout_time": logoutTime,
    "driver": driver?.toJson(),
  };
}

class Driver {
  String? username;

  Driver({
    this.username,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
  };
}